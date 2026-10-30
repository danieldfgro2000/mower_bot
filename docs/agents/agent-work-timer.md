# Agent Work Timer

The native JetBrains plugin in [tool/agent-work-timer](../../tool/agent-work-timer/)
measures a task from an **explicit Start action** to **Complete**. It is an
opt-in local observer, not a Copilot extension that can read agent internals.
The [documented Copilot hooks](https://docs.github.com/en/copilot/concepts/customizations/hooks)
do not currently document JetBrains lifecycle support; do not assume CLI hooks
run inside the IDE.

## Build and install

Requirements: Node.js 20+, a JetBrains IDE installation with its SDK jars and a
JDK able to read those jars. The current descriptor requires IntelliJ Platform
build **262 or newer**. The first compilation used the locally installed Android
Studio 262 SDK and its bundled JDK 25. Other IDE versions require separate
compatibility validation; compilation is not a live IDE smoke test.

From the repository root:

```sh
node tool/agent-work-timer/test.mjs
node tool/agent-work-timer/build.mjs "/path/to/your/JetBrains IDE installation"
```

The build uses the installed IDE's bundled JDK, or `JAVA_HOME` if explicitly
set. `IDEA_HOME` can supply the IDE installation instead of the positional
argument. There are no package downloads, Gradle setup, marketplace uploads
or modifications to the installed IDE. The build replaces only this plugin's
ignored `tool/agent-work-timer/build/` directory.

Install `tool/agent-work-timer/build/agent-work-timer-0.1.0.zip` using
**Settings > Plugins > gear > Install Plugin from Disk**, then restart if the
IDE requests it. Open **View > Tool Windows > Agent Work Timer**. Building
does not install the plugin or instrument the current conversation.

## Record a task

1. Click **Start task (before prompt)** immediately before submitting a prompt.
   The initial phase is `INVESTIGATE`. This boundary is an approximation of
   prompt receipt; the plugin cannot observe Copilot receiving it.
2. Select a phase and click **Begin selected phase / checkpoint** when the
   activity changes. Available phases are investigation, implementation,
   validation, waiting for the user, waiting for the environment, review and
   other. Repeating a phase records another timestamped checkpoint.
3. Click **Complete (agent ready)** only when the agent has finished and is ready
   for another task. **Cancel task** records a distinct cancelled outcome.
   Neither action stops Copilot or terminates any IDE/terminal process.
4. Click **Reveal latest report** to locate the Markdown report and adjacent
   JSONL event stream. Each task has a new UUID directory.

There is one active recording per project. Different projects can record
independently. The tool window must have been opened to initialize observation;
it continues recording when the window is hidden. It does not collect anything
while idle or restore an active task across IDE restarts.

## What is measured

| Signal | Capture and meaning |
| --- | --- |
| Start, phase/checkpoint, complete, cancel | Explicit button actions; UTC timestamps and monotonic elapsed milliseconds |
| IDE run/debug start and termination | Automatic for executions started during the recording; numeric execution ID and success/failure, no configuration name |
| Project document edits | Automatic aggregate count of document-change events, flushed every five seconds and before a manual phase/end action |
| Running snapshot | Heartbeat every five seconds; no activity is inferred from a heartbeat |
| Project close/plugin disposal | Attempts to record `INTERRUPTED`, never a successful completion |

Callbacks are serialized on one background worker. Timestamps mark recording
on that worker, not a supported Copilot event, so queuing and manual reaction
time affect precision. User waits are included in total elapsed time; mark them
explicitly to separate them from other phases. Duration uses `System.nanoTime`
instead of subtracting wall timestamps, so wall-clock corrections do not alter
elapsed time.

The Markdown report ranks phase totals and IDE runs, includes the full event
timeline, and reports **union coverage** of overlapping run intervals. Phase
totals partition task elapsed time. Run intervals overlap those phases: do not
add the two sets of durations or sum concurrent runs as elapsed time.

Use the longest phase to choose an investigation target, then inspect the run
timeline for failures and overlapping work. `WAIT_USER` and `WAIT_ENVIRONMENT`
are human-supplied context, not detected diagnoses. Failure and long duration
are evidence to investigate, not proof of a root cause.

### Observation limits

- There is no automatic access to prompt submission, readiness, tool names,
  internal reasoning, token latency, remote agents or Copilot subagents.
- Terminal commands, agent tool executions, file reads/searches and external
  processes are not IDE Run/Debug events and are not timed automatically.
- Document changes include human and agent edits; counts are not lines changed,
  all filesystem writes or attribution to a particular actor. Batch timestamps
  identify the flush, not each keystroke.
- Runs already active at Start are excluded. Runs still active at Complete are
  clipped to that task boundary and labelled `INCOMPLETE`.
- Time outside observed IDE runs remains **unattributed**. It is not necessarily
  inactivity or model reasoning. Manual phase selection is essential for useful
  end-to-end optimization in the absence of a supported agent event stream.
- An abrupt exit leaves a `RUNNING` snapshot through the last recorded event,
  not a fabricated completion. Interrupted/cancelled tasks are not completed
  tasks. Recording errors appear in an IDE notification, status and IDE log;
  that task's data may be incomplete. If storage recovers, subsequent reports
  retain a `_WITH_RECORDING_ERRORS` status rather than hiding the earlier loss.

## Local data and overhead

Files live under the IDE's system/cache directory:
`agent-work-timer/<project-location-hash>/<task-uuid>/events.jsonl` and
`report.md`. Reveal the report rather than assuming an OS-specific system path.
Reports refresh on every recorded event; each JSONL event is appended before
the report is replaced. Files are outside the repository and have no network
transport. Directories are owner-only on POSIX; Windows uses inherited access
controls.

No prompt text, source, paths, command arguments, configuration names, tool
output or freeform notes are logged. The IDE supplies the opaque project hash;
run IDs are numeric. Events still reveal activity times and should be treated as
local diagnostic data. There is no automatic deletion/retention policy: delete
the relevant task directories when no longer needed, after ending recording.
Uninstalling the plugin does not promise deletion of IDE cache data.

Editor callbacks only increment a counter. File writes and report generation
run off the UI thread; the display refreshes every half second. The plugin
does not poll Copilot logs, instrument its classes, send telemetry or collect
private reasoning. Heartbeats keep interrupted-task snapshots useful without
claiming the agent was active between observations.

## Test-first evidence

`node tool/agent-work-timer/test.mjs` compiles the IDE-independent core using a
JDK 21+ and runs deterministic tests with an injected clock. The initial
scaffold failed `start must activate a task` before implementation. The
heartbeat/interruption extension separately failed `heartbeat persists a
running snapshot even without observed work` before implementation.
The storage-recovery regression failed `recovered storage must not hide a
prior recording failure` before adding the sticky incomplete-data marker.

The passing cases cover lifecycle guards, timestamps, overlapping runs, phase
ranking, failed/open runs, edit batching, wall-clock changes, JSONL escaping,
new-task isolation, cancellation, interruption, heartbeats and I/O errors.
The plugin adapter is compiled against the installed SDK; installation and
live event delivery still require an IDE smoke test. After installing, start a
recording, change a project document, start two overlapping IDE runs, switch
phase and complete. Confirm the report's duration, timestamps and union
coverage. Also try Cancel and project close; neither should produce COMPLETE.
