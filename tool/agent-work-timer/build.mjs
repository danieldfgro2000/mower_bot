import { cpSync, existsSync, mkdirSync, readdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';

const root = path.dirname(fileURLToPath(import.meta.url));
const ide = process.argv[2] || process.env.IDEA_HOME;
if (!ide) throw new Error('Usage: node build.mjs <IDE installation directory> (or set IDEA_HOME)');
const home = path.resolve(ide, existsSync(path.join(ide, 'Contents', 'lib')) ? 'Contents' : '.');
const javaHome = process.env.JAVA_HOME || [
  path.join(home, 'jbr', 'Contents', 'Home'), path.join(home, 'jbr'),
].find(candidate => existsSync(path.join(candidate, 'bin', 'javac')));
if (!javaHome) throw new Error('Set JAVA_HOME to a JDK capable of reading this IDE SDK (JDK 25 for build 262).');
const files = (directory, suffix) => readdirSync(directory, { withFileTypes: true })
  .flatMap(entry => entry.isDirectory() ? files(path.join(directory, entry.name), suffix)
    : entry.name.endsWith(suffix) ? [path.join(directory, entry.name)] : []);
const jars = files(path.join(home, 'lib'), '.jar');
if (!jars.length) throw new Error(`No IDE SDK jars found under ${home}/lib`);
const output = path.join(root, 'build');
// This tool owns only its own build output, not the repository or IDE installation.
rmSync(output, { recursive: true, force: true });
const classes = path.join(output, 'classes');
const lib = path.join(output, 'package', 'agent-work-timer', 'lib');
mkdirSync(classes, { recursive: true });
mkdirSync(lib, { recursive: true });
const quote = value => `"${value.replaceAll('\\', '\\\\').replaceAll('"', '\\"')}"`;
const argumentsFile = path.join(output, 'javac.args');
writeFileSync(argumentsFile, ['--release', '21', '-encoding', 'UTF-8', '-classpath',
  quote(jars.join(path.delimiter)), '-d', quote(classes),
  ...files(path.join(root, 'src', 'main', 'java'), '.java').map(quote)].join('\n'));
function run(name, args) {
  const command = path.join(javaHome, 'bin', process.platform === 'win32' ? `${name}.exe` : name);
  const result = spawnSync(command, args, { stdio: 'inherit' });
  if (result.error) throw result.error;
  if (result.status !== 0) throw new Error(`${name} exited ${result.status}`);
}
run('javac', [`@${argumentsFile}`]);
cpSync(path.join(root, 'src', 'main', 'resources'), classes, { recursive: true });
run('jar', ['--create', '--file', path.join(lib, 'agent-work-timer.jar'), '-C', classes, '.']);
const zip = path.join(output, 'agent-work-timer-0.1.0.zip');
run('jar', ['--create', '--no-manifest', '--file', zip, '-C', path.join(output, 'package'), '.']);
const descriptor = readFileSync(path.join(classes, 'META-INF', 'plugin.xml'), 'utf8');
if (!descriptor.includes('dev.mowerbot.timer.TimingToolWindow')) throw new Error('Missing plugin descriptor');
console.log(`Built ${zip}`);
