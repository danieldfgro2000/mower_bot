package dev.mowerbot.timer;

import com.intellij.execution.ExecutionListener;
import com.intellij.execution.ExecutionManager;
import com.intellij.execution.process.ProcessHandler;
import com.intellij.execution.runners.ExecutionEnvironment;
import com.intellij.openapi.Disposable;
import com.intellij.openapi.application.PathManager;
import com.intellij.openapi.diagnostic.Logger;
import com.intellij.openapi.editor.EditorFactory;
import com.intellij.openapi.editor.event.DocumentEvent;
import com.intellij.openapi.editor.event.DocumentListener;
import com.intellij.openapi.fileEditor.FileDocumentManager;
import com.intellij.openapi.project.Project;
import com.intellij.openapi.roots.ProjectFileIndex;
import com.intellij.notification.NotificationGroupManager;
import com.intellij.notification.NotificationType;
import java.io.IOException;
import java.nio.file.Path;
import java.time.Instant;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicLong;

public final class TimingService implements Disposable {
    private static final Logger LOG = Logger.getInstance(TimingService.class);
    private final Project project;
    private final ScheduledExecutorService worker = Executors.newSingleThreadScheduledExecutor(runnable -> {
        Thread thread = new Thread(runnable, "agent-work-timer");
        thread.setDaemon(true);
        return thread;
    });
    private final TaskTimer timer;
    private final AtomicLong edits = new AtomicLong();
    private final Set<String> observedRuns = new HashSet<>();
    private volatile String status = "Idle - press Start immediately before submitting a prompt.";
    private volatile String recordingError;
    private volatile boolean disposed;
    private volatile long displayStartedNanos;

    public TimingService(Project project) {
        this.project = project;
        timer = new TaskTimer(Path.of(PathManager.getSystemPath(), "agent-work-timer", project.getLocationHash()),
                () -> new TaskTimer.Stamp(Instant.now(), System.nanoTime()));
        project.getMessageBus().connect(this).subscribe(ExecutionManager.EXECUTION_TOPIC, new ExecutionListener() {
            @Override
            public void processStarted(String executorId, ExecutionEnvironment environment, ProcessHandler handler) {
                submit(() -> {
                    if (timer.isActive()) {
                        String id = Long.toString(environment.getExecutionId());
                        timer.runStarted(id);
                        observedRuns.add(id);
                    }
                });
            }

            @Override
            public void processTerminated(String executorId, ExecutionEnvironment environment,
                                          ProcessHandler handler, int exitCode) {
                submit(() -> {
                    String id = Long.toString(environment.getExecutionId());
                    if (timer.isActive() && observedRuns.remove(id)) timer.runFinished(id, exitCode == 0);
                });
            }
        });
        EditorFactory.getInstance().getEventMulticaster().addDocumentListener(new DocumentListener() {
            @Override
            public void documentChanged(DocumentEvent event) {
                if (!timer.isActive()) return;
                var file = FileDocumentManager.getInstance().getFile(event.getDocument());
                if (file != null && ProjectFileIndex.getInstance(project).isInContent(file)) edits.incrementAndGet();
            }
        }, this);
        worker.scheduleWithFixedDelay(() -> safely(() -> {
            if (timer.isActive()) {
                flushEdits();
                timer.heartbeat();
            }
        }), 5, 5, TimeUnit.SECONDS);
    }

    public void start() {
        submit(() -> {
            timer.start();
            observedRuns.clear();
            edits.set(0);
            displayStartedNanos = System.nanoTime();
            recordingError = null;
            status = "Recording - INVESTIGATE";
        });
    }

    public void phase(TaskTimer.Phase phase) {
        submit(() -> {
            flushEdits();
            timer.phase(phase);
            status = "Recording - " + phase;
        });
    }

    public void finish(boolean cancelled) {
        submit(() -> {
            flushEdits();
            timer.finish(cancelled);
            status = (cancelled ? "Cancelled" : "Complete") + " - report saved";
        });
    }

    public boolean isActive() { return timer.isActive(); }
    public String status() { return recordingError == null ? status : recordingError; }
    public Path reportPath() { return timer.reportPath(); }
    public long elapsedSeconds() { return (System.nanoTime() - displayStartedNanos) / 1_000_000_000L; }

    private void flushEdits() throws IOException {
        long count = edits.getAndSet(0);
        if (count > 0) timer.edits(count);
    }

    private void submit(Recording action) {
        synchronized (worker) {
            if (!disposed) worker.execute(() -> safely(action));
        }
    }

    private void safely(Recording action) {
        try {
            action.run();
        } catch (IOException | IllegalStateException | IllegalArgumentException | SecurityException error) {
            recordingError = "Recording error - " + error.getClass().getSimpleName() + "; see IDE log";
            LOG.warn("Agent work timer could not record an event", error);
            NotificationGroupManager.getInstance().getNotificationGroup("Agent Work Timer")
                    .createNotification("Agent work timer recording error",
                            "An event or report could not be saved. Check the IDE log; this task's timing may be incomplete.",
                            NotificationType.ERROR).notify(project);
        }
    }

    @Override
    public void dispose() {
        synchronized (worker) {
            disposed = true;
            worker.execute(() -> safely(() -> {
                if (timer.isActive()) {
                    flushEdits();
                    timer.interrupt();
                }
            }));
            worker.shutdown();
        }
    }

    private interface Recording { void run() throws IOException; }
}
