#!/usr/bin/env zsh
set -euo pipefail

# Runs all Flutter tests with coverage and writes a stable summary file.
# This avoids depending on terminal output capture.

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

flutter test --coverage
python3 tool/coverage_summary.py

echo "Wrote coverage/summary.txt"

