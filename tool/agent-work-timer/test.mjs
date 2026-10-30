import { mkdtempSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';

const root = path.dirname(fileURLToPath(import.meta.url));
const output = mkdtempSync(path.join(tmpdir(), 'agent-timer-classes-'));
const java = name => process.env.JAVA_HOME ? path.join(process.env.JAVA_HOME, 'bin', name) : name;
function run(command, args) {
  const result = spawnSync(command, args, { stdio: 'inherit', cwd: root });
  if (result.error) throw result.error;
  if (result.status !== 0) throw new Error(`${command} exited ${result.status}`);
}
try {
  run(java('javac'), ['--release', '21', '-d', output,
    'src/main/java/dev/mowerbot/timer/TaskTimer.java',
    'src/main/java/dev/mowerbot/timer/TimerReport.java',
    'src/test/java/dev/mowerbot/timer/TaskTimerTest.java']);
  run(java('java'), ['-cp', output, 'dev.mowerbot.timer.TaskTimerTest']);
} finally {
  rmSync(output, { recursive: true, force: true });
}
