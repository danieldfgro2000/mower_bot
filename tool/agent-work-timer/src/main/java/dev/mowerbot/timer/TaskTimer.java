package dev.mowerbot.timer;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.nio.file.attribute.PosixFilePermissions;
import java.time.Instant;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;
import java.util.function.Supplier;

public final class TaskTimer {
    public record Stamp(Instant wall, long nanos) {}
    public enum Phase { INVESTIGATE, IMPLEMENT, VALIDATE, WAIT_USER, WAIT_ENVIRONMENT, REVIEW, OTHER }
    record Event(Instant timestamp, long elapsedMs, String name, String detail) {}
    record Segment(Phase phase, long durationMs) {}
    record Run(String id, long startMs, Long endMs, String status) {}

    private final Path directory;
    private final Supplier<Stamp> clock;
    private final List<Event> events = new ArrayList<>();
    private final List<Segment> segments = new ArrayList<>();
    private final Map<String, Run> runs = new LinkedHashMap<>();
    private Stamp start;
    private Phase phase;
    private long phaseStartMs;
    private long editCount;
    private volatile boolean active;
    private volatile Path report;
    private String status;
    private boolean dataIncomplete;

    public TaskTimer(Path directory, Supplier<Stamp> clock) {
        this.directory = Objects.requireNonNull(directory);
        this.clock = Objects.requireNonNull(clock);
    }

    public void start() throws IOException {
        if (active) throw new IllegalStateException("Complete or cancel the current task first.");
        privateDirectory(directory);
        Path task = directory.resolve(UUID.randomUUID().toString());
        privateDirectory(task);
        report = task.resolve("report.md");
        events.clear();
        segments.clear();
        runs.clear();
        editCount = 0;
        phase = Phase.INVESTIGATE;
        phaseStartMs = 0;
        status = "RUNNING";
        dataIncomplete = false;
        start = clock.get();
        active = true;
        try {
            record(start, "task_start", "Explicit start boundary; initial phase INVESTIGATE");
        } catch (IOException error) {
            active = false;
            throw error;
        }
    }

    public void phase(Phase next) throws IOException {
        requireActive();
        Objects.requireNonNull(next);
        Stamp now = clock.get();
        closePhase(now);
        phase = next;
        record(now, "phase", next.name());
    }

    public void runStarted(String id) throws IOException {
        requireActive();
        Objects.requireNonNull(id);
        if (runs.containsKey(id)) throw new IllegalStateException("Duplicate IDE run: " + id);
        Stamp now = clock.get();
        runs.put(id, new Run(id, elapsed(now), null, "INCOMPLETE"));
        record(now, "ide_run_start", id);
    }

    public void runFinished(String id, boolean success) throws IOException {
        requireActive();
        Run run = runs.get(id);
        if (run == null || run.endMs() != null) throw new IllegalStateException("Unknown active IDE run: " + id);
        Stamp now = clock.get();
        runs.put(id, new Run(id, run.startMs(), elapsed(now), success ? "SUCCESS" : "FAILED"));
        record(now, "ide_run_end", id + (success ? " SUCCESS" : " FAILED"));
    }

    public void edits(long count) throws IOException {
        requireActive();
        if (count < 0) throw new IllegalArgumentException("Edit count must not be negative.");
        if (count == 0) return;
        editCount += count;
        record(clock.get(), "document_edits", Long.toString(count));
    }

    public void finish(boolean cancelled) throws IOException {
        stop(cancelled ? "CANCELLED" : "COMPLETE", cancelled ? "task_cancel" : "task_complete");
    }

    public void interrupt() throws IOException {
        stop("INTERRUPTED", "task_interrupted");
    }

    public void heartbeat() throws IOException {
        requireActive();
        record(clock.get(), "heartbeat", "Running snapshot; no activity inferred");
    }

    private void stop(String finalStatus, String event) throws IOException {
        requireActive();
        Stamp now = clock.get();
        closePhase(now);
        status = finalStatus;
        active = false;
        record(now, event, status);
    }

    public boolean isActive() { return active; }
    public Path reportPath() { return report; }

    private void closePhase(Stamp now) {
        long end = elapsed(now);
        segments.add(new Segment(phase, end - phaseStartMs));
        phaseStartMs = end;
    }

    private long elapsed(Stamp stamp) {
        return (stamp.nanos() - start.nanos()) / 1_000_000;
    }

    private void requireActive() {
        if (!active) throw new IllegalStateException("Start a task before recording activity.");
    }

    private void record(Stamp now, String event, String detail) throws IOException {
        Event entry = new Event(now.wall(), elapsed(now), event, detail);
        try {
            Files.writeString(report.resolveSibling("events.jsonl"), TimerReport.json(entry) + "\n",
                    StandardOpenOption.CREATE, StandardOpenOption.APPEND);
            events.add(entry);
            List<Segment> current = new ArrayList<>(segments);
            if (active) current.add(new Segment(phase, elapsed(now) - phaseStartMs));
            TimerReport.write(report, status + (dataIncomplete ? "_WITH_RECORDING_ERRORS" : ""),
                    elapsed(now), editCount, current, runs.values(), events);
        } catch (IOException error) {
            dataIncomplete = true;
            throw error;
        }
    }

    private static void privateDirectory(Path path) throws IOException {
        Files.createDirectories(path);
        if (path.getFileSystem().supportedFileAttributeViews().contains("posix")) {
            Files.setPosixFilePermissions(path, PosixFilePermissions.fromString("rwx------"));
        }
    }
}
