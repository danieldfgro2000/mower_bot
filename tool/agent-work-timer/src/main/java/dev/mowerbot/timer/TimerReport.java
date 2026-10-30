package dev.mowerbot.timer;

import java.io.IOException;
import java.nio.file.AtomicMoveNotSupportedException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.Collection;
import java.util.Comparator;
import java.util.EnumMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

final class TimerReport {
    private TimerReport() {}

    static void write(Path path, String status, long elapsed, long edits,
                      List<TaskTimer.Segment> segments, Collection<TaskTimer.Run> runs,
                      List<TaskTimer.Event> events) throws IOException {
        Map<TaskTimer.Phase, Long> totals = new EnumMap<>(TaskTimer.Phase.class);
        segments.forEach(segment -> totals.merge(segment.phase(), segment.durationMs(), Long::sum));
        long coverage = coverage(runs, elapsed);
        long failed = runs.stream().filter(run -> run.status().equals("FAILED")).count();
        StringBuilder text = new StringBuilder("# Agent work timing\n\n")
                .append("Status: ").append(status).append("\n\n")
                .append("Elapsed: ").append(seconds(elapsed)).append("\n\n")
                .append("IDE run coverage: ").append(seconds(coverage)).append("\n\n")
                .append("Outside observed IDE runs: ").append(seconds(elapsed - coverage)).append("\n\n")
                .append("Failed IDE runs: ").append(failed).append("\n\n")
                .append("Observed document edits: ").append(edits).append("\n\n")
                .append("## Slowest phases\n\n| Phase | Duration |\n| --- | --- |\n");
        totals.entrySet().stream().sorted(Map.Entry.<TaskTimer.Phase, Long>comparingByValue().reversed())
                .forEach(entry -> text.append("| ").append(entry.getKey()).append(" | ")
                        .append(seconds(entry.getValue())).append(" |\n"));
        text.append("\n## IDE runs (longest first)\n\n| Run ID | Duration | Status |\n| --- | --- | --- |\n");
        runs.stream().sorted(Comparator.comparingLong((TaskTimer.Run run) -> duration(run, elapsed)).reversed())
                .forEach(run -> text.append("| ").append(markdown(run.id())).append(" | ")
                        .append(seconds(duration(run, elapsed))).append(" | ").append(run.status()).append(" |\n"));
        text.append("\n## Timeline\n\n| Timestamp (UTC) | Elapsed | Event | Detail |\n| --- | --- | --- | --- |\n");
        events.forEach(event -> text.append("| ").append(event.timestamp()).append(" | ")
                .append(seconds(event.elapsedMs())).append(" | ").append(event.name()).append(" | ")
                .append(markdown(event.detail())).append(" |\n"));
        text.append("\n## Interpretation and limits\n\n")
                .append("- Boundaries and phases are explicit user actions, not Copilot lifecycle events. ")
                .append("Start immediately before submitting a prompt; Complete only when the agent is ready.\n")
                .append("- Elapsed time includes user waits. Durations use a monotonic clock; timestamps use UTC.\n")
                .append("- Phase totals partition elapsed time. IDE run coverage merges overlapping runs; ")
                .append("do not add it to phase totals or sum concurrent run durations as wall time.\n")
                .append("- Document edits include any editor, not just the agent. Edit timestamps mark batch flushes.\n")
                .append("- IDE runs exclude Copilot tools, terminal commands and remote/subagent execution. ")
                .append("Unobserved time is NOT evidence of model reasoning, inactivity or a root cause.\n")
                .append("- RUNNING reports are snapshots through the last recorded event, not completed tasks. ")
                .append("An abrupt IDE exit leaves them unfinished. INCOMPLETE runs may outlive task completion.\n");
        if (status.endsWith("_WITH_RECORDING_ERRORS")) text.append("- Recording errors occurred in this task. ")
                .append("Its timeline may be incomplete even if storage later recovered; inspect IDE diagnostics.\n");
        if (failed > 0) text.append("- Investigate failed IDE runs for retries or environment errors; ")
                .append("failure alone does not establish a root cause.\n");
        if (totals.containsKey(TaskTimer.Phase.WAIT_USER)) text.append("- User-wait phase observed: ")
                .append("review approval/clarification delays separately from agent work.\n");
        if (totals.containsKey(TaskTimer.Phase.WAIT_ENVIRONMENT)) text.append("- Environment-wait phase observed: ")
                .append("inspect tool startup, downloads and build prerequisites; the label is manually supplied.\n");
        Path temporary = path.resolveSibling("report.tmp");
        Files.writeString(temporary, text);
        try {
            Files.move(temporary, path, StandardCopyOption.ATOMIC_MOVE, StandardCopyOption.REPLACE_EXISTING);
        } catch (AtomicMoveNotSupportedException error) {
            Files.move(temporary, path, StandardCopyOption.REPLACE_EXISTING);
        }
    }

    private static long duration(TaskTimer.Run run, long end) {
        return (run.endMs() == null ? end : run.endMs()) - run.startMs();
    }

    private static long coverage(Collection<TaskTimer.Run> runs, long end) {
        long total = 0;
        long right = 0;
        for (TaskTimer.Run run : runs.stream().sorted(Comparator.comparingLong(TaskTimer.Run::startMs)).toList()) {
            long until = run.endMs() == null ? end : run.endMs();
            total += Math.max(0, until - Math.max(right, run.startMs()));
            right = Math.max(right, until);
        }
        return total;
    }

    private static String seconds(long millis) {
        return String.format(Locale.ROOT, "%.3f s", millis / 1000.0);
    }

    private static String markdown(String value) {
        return value.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("|", "&#124;").replace("\r", " ").replace("\n", " ");
    }

    static String json(TaskTimer.Event event) {
        return "{\"timestamp\":" + quote(event.timestamp().toString()) + ",\"elapsedMs\":" + event.elapsedMs()
                + ",\"event\":" + quote(event.name()) + ",\"detail\":" + quote(event.detail()) + "}";
    }

    private static String quote(String value) {
        StringBuilder result = new StringBuilder("\"");
        for (char character : value.toCharArray()) {
            switch (character) {
                case '"' -> result.append("\\\"");
                case '\\' -> result.append("\\\\");
                case '\n' -> result.append("\\n");
                case '\r' -> result.append("\\r");
                case '\t' -> result.append("\\t");
                default -> {
                    if (character < 32) result.append(String.format(Locale.ROOT, "\\u%04x", (int) character));
                    else result.append(character);
                }
            }
        }
        return result.append('"').toString();
    }
}
