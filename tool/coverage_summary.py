#!/usr/bin/env python3
"""Generate human-friendly coverage summaries from LCOV.

Writes a deterministic summary to coverage/summary.txt. This is useful when IDE
terminal output capture is flaky.

Usage:
  python3 tool/coverage_summary.py
  python3 tool/coverage_summary.py --lcov coverage/lcov.info --out coverage/summary.txt --top 25
"""

from __future__ import annotations

import argparse
from dataclasses import dataclass
from pathlib import Path


@dataclass(frozen=True)
class FileCoverage:
    path: str
    lines_hit: int
    lines_found: int

    @property
    def pct(self) -> float:
        if self.lines_found == 0:
            return 100.0
        return (self.lines_hit / self.lines_found) * 100.0


def parse_lcov_text(text: str) -> list[FileCoverage]:
    current_sf: str | None = None
    current_lf: int | None = None
    current_lh: int | None = None
    out: list[FileCoverage] = []

    def flush() -> None:
        nonlocal current_sf, current_lf, current_lh
        if current_sf is None:
            return
        lf = int(current_lf or 0)
        lh = int(current_lh or 0)
        out.append(FileCoverage(path=current_sf, lines_hit=lh, lines_found=lf))
        current_sf = None
        current_lf = None
        current_lh = None

    for raw in text.splitlines():
        line = raw.strip()
        if line.startswith("SF:"):
            flush()
            current_sf = line[3:]
        elif line.startswith("LF:"):
            current_lf = int(line[3:] or 0)
        elif line.startswith("LH:"):
            current_lh = int(line[3:] or 0)
        elif line == "end_of_record":
            flush()

    flush()
    return out


def is_lib_source(path: str) -> bool:
    # Flutter LCOV often includes absolute paths.
    # We only care about app code under lib/.
    p = path.replace("\\", "/")
    return "/lib/" in p and not "/.dart_tool/" in p


def normalize_to_repo_relative(path: str, repo_root: Path) -> str:
    p = Path(path)
    try:
        return str(p.resolve().relative_to(repo_root.resolve()))
    except Exception:
        # Fall back to a best-effort lib/… suffix.
        s = str(p).replace("\\", "/")
        idx = s.rfind("/lib/")
        if idx != -1:
            return s[idx + 1 :]
        return str(p)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--lcov", default="coverage/lcov.info")
    ap.add_argument("--out", default="coverage/summary.txt")
    ap.add_argument("--top", type=int, default=25)
    args = ap.parse_args()

    repo_root = Path(__file__).resolve().parents[1]
    lcov_path = (repo_root / args.lcov).resolve()
    out_path = (repo_root / args.out).resolve()

    if not lcov_path.exists():
        out_path.parent.mkdir(parents=True, exist_ok=True)
        out_path.write_text(
            f"Coverage summary\n\nERROR: LCOV file not found: {lcov_path}\n", encoding="utf-8"
        )
        return 2

    cov = parse_lcov_text(lcov_path.read_text(encoding="utf-8"))
    lib_cov = [c for c in cov if is_lib_source(c.path)]

    total_lf = sum(c.lines_found for c in lib_cov)
    total_lh = sum(c.lines_hit for c in lib_cov)
    total_pct = (total_lh / total_lf * 100.0) if total_lf else 100.0

    # Sort: lowest first, then by most lines missing, then path.
    def sort_key(c: FileCoverage):
        missing = c.lines_found - c.lines_hit
        return (c.pct, -missing, c.path)

    worst = sorted(lib_cov, key=sort_key)[: max(args.top, 0)]

    lines: list[str] = []
    lines.append("Coverage summary (lib/ only)")
    lines.append("")
    lines.append(f"TOTAL: {total_pct:.2f}% ({total_lh}/{total_lf} lines)")
    lines.append("")

    if not worst:
        lines.append("No lib/ files found in LCOV input.")
    else:
        lines.append(f"Lowest-covered files (top {len(worst)}):")
        for c in worst:
            rel = normalize_to_repo_relative(c.path, repo_root)
            missing = c.lines_found - c.lines_hit
            lines.append(
                f"- {c.pct:6.2f}%  {c.lines_hit:5d}/{c.lines_found:<5d}  missing={missing:<5d}  {rel}"
            )
    lines.append("")

    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text("\n".join(lines), encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

