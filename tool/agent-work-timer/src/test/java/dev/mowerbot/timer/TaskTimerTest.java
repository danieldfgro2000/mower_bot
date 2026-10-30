package dev.mowerbot.timer;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Instant;
import java.util.Comparator;

public final class TaskTimerTest {
    private static final Instant ORIGIN = Instant.parse("2026-10-30T10:00:00Z");
    private static int assertions;
    private static long seconds;
    private static Instant wall = ORIGIN;

    public static void main(String[] args) throws Exception {
        Path root = Files.createTempDirectory("agent-timer-tests-");
        try {
            lifecycleAndOverlap(root.resolve("overlap"));
            unfinishedAndCancelled(root.resolve("cancel"));
            heartbeatAndInterrupt(root.resolve("interrupt"));
            clockChangesAndEscaping(root.resolve("clock"));
            invalidTransitions(root.resolve("invalid"));
            ioErrors(root.resolve("io"));
            recordingFailureRemainsVisible(root.resolve("partial"));
            System.out.println("TaskTimer: " + assertions + " assertions passed");
        } finally {
            try (var files = Files.walk(root)) {
                for (Path file : files.sorted(Comparator.reverseOrder()).toList()) Files.delete(file);
            }
        }
    }

    private static TaskTimer timer(Path path) {
        seconds = 0;
        wall = ORIGIN;
        return new TaskTimer(path, () -> new TaskTimer.Stamp(wall, seconds * 1_000_000_000L));
    }

    private static void at(long time) {
        seconds = time;
        wall = ORIGIN.plusSeconds(time);
    }

    private static void lifecycleAndOverlap(Path path) throws Exception {
        TaskTimer timer = timer(path);
        timer.start();
        check(timer.isActive(), "start must activate a task");
        at(2);
        timer.runStarted("a");
        at(4);
        timer.phase(TaskTimer.Phase.VALIDATE);
        timer.runStarted("b");
        at(6);
        timer.runFinished("a", true);
        at(7);
        timer.edits(5);
        at(8);
        timer.runFinished("b", false);
        at(10);
        timer.finish(false);
        check(!timer.isActive(), "complete must stop recording");
        String report = Files.readString(timer.reportPath());
        check(report.contains("Status: COMPLETE"), "completed status");
        check(report.contains("Elapsed: 10.000 s"), "prompt-boundary to complete wall duration");
        check(report.contains("IDE run coverage: 6.000 s"), "overlapping runs use union, not sum");
        check(report.contains("Outside observed IDE runs: 4.000 s"), "unattributed gap");
        check(report.contains("| VALIDATE | 6.000 s |"), "phase durations");
        check(report.contains("| INVESTIGATE | 4.000 s |"), "first phase duration");
        check(report.contains("Failed IDE runs: 1"), "failures must remain visible");
        check(report.contains("Observed document edits: 5"), "aggregated edit count");
        check(report.contains("2026-10-30T10:00:07Z"), "each step has wall timestamp");
        check(report.indexOf("| VALIDATE |") < report.indexOf("| INVESTIGATE |"), "slowest phases first");
        String json = Files.readString(timer.reportPath().resolveSibling("events.jsonl"));
        check(json.lines().count() == 8, "eight recorded actions must produce eight events");
        check(json.contains("\"elapsedMs\":10000"), "JSONL carries monotonic duration");
        check(json.contains("\"event\":\"task_complete\""), "explicit completion event");
    }

    private static void unfinishedAndCancelled(Path path) throws Exception {
        TaskTimer timer = timer(path);
        timer.start();
        Path first = timer.reportPath();
        at(3);
        timer.runStarted("unfinished");
        at(5);
        timer.phase(TaskTimer.Phase.WAIT_USER);
        check(Files.readString(first).contains("Status: RUNNING"), "crash leaves running, not complete");
        at(9);
        timer.finish(true);
        String report = Files.readString(first);
        check(report.contains("Status: CANCELLED"), "cancel is distinct from complete");
        check(report.contains("INCOMPLETE"), "open executions are not marked successful");
        check(report.contains("IDE run coverage: 6.000 s"), "open span clipped to task boundary");
        timer.start();
        check(!first.equals(timer.reportPath()), "new tasks cannot overwrite old tasks");
        timer.finish(false);
    }

    private static void clockChangesAndEscaping(Path path) throws Exception {
        TaskTimer timer = timer(path);
        timer.start();
        seconds = 2;
        wall = ORIGIN.minusSeconds(500);
        timer.runStarted("quote\"line\n");
        seconds = 3;
        timer.runFinished("quote\"line\n", true);
        seconds = 4;
        timer.finish(false);
        check(Files.readString(timer.reportPath()).contains("Elapsed: 4.000 s"),
                "wall clock adjustments cannot corrupt durations");
        String json = Files.readString(timer.reportPath().resolveSibling("events.jsonl"));
        check(json.contains("quote\\\"line\\n"), "JSON strings escaped");
        check(json.lines().count() == 4, "embedded newline cannot inject JSONL events");
    }

    private static void heartbeatAndInterrupt(Path path) throws Exception {
        TaskTimer timer = timer(path);
        timer.start();
        at(30);
        timer.heartbeat();
        check(Files.readString(timer.reportPath()).contains("Elapsed: 30.000 s"),
                "heartbeat persists a running snapshot even without observed work");
        at(35);
        timer.interrupt();
        check(!timer.isActive(), "IDE close interrupts task recording");
        String report = Files.readString(timer.reportPath());
        check(report.contains("Status: INTERRUPTED"), "IDE close is not user cancellation or completion");
        check(report.contains("Elapsed: 35.000 s"), "interruption closes timing interval");
    }

    private static void invalidTransitions(Path path) throws Exception {
        TaskTimer timer = timer(path);
        fails(IllegalStateException.class, () -> timer.finish(false));
        timer.start();
        fails(IllegalStateException.class, timer::start);
        fails(IllegalStateException.class, () -> timer.runFinished("absent", true));
        timer.runStarted("same");
        fails(IllegalStateException.class, () -> timer.runStarted("same"));
        fails(IllegalArgumentException.class, () -> timer.edits(-1));
        timer.finish(false);
        fails(IllegalStateException.class, () -> timer.phase(TaskTimer.Phase.REVIEW));
    }

    private static void ioErrors(Path path) throws Exception {
        Files.writeString(path, "not a directory");
        TaskTimer timer = timer(path);
        fails(IOException.class, timer::start);
        check(!timer.isActive(), "failed start cannot look active");
    }

    private static void recordingFailureRemainsVisible(Path path) throws Exception {
        TaskTimer timer = timer(path);
        timer.start();
        Path events = timer.reportPath().resolveSibling("events.jsonl");
        Path saved = events.resolveSibling("events.saved");
        Files.move(events, saved);
        Files.createDirectory(events);
        at(2);
        fails(IOException.class, () -> timer.edits(4));
        Files.delete(events);
        Files.move(saved, events);
        at(3);
        timer.finish(false);
        check(Files.readString(timer.reportPath()).contains("Status: COMPLETE_WITH_RECORDING_ERRORS"),
                "recovered storage must not hide a prior recording failure");
    }

    private static void check(boolean condition, String reason) {
        assertions++;
        if (!condition) throw new AssertionError(reason);
    }

    private static void fails(Class<? extends Exception> type, Throwing action) throws Exception {
        try {
            action.run();
        } catch (Exception error) {
            check(type.isInstance(error), "expected " + type + ", got " + error);
            return;
        }
        throw new AssertionError("Expected " + type.getSimpleName());
    }

    private interface Throwing { void run() throws Exception; }
}
