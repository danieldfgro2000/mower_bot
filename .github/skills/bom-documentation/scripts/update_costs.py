"""Generate linked BOM tables from the CSV owners; --check never writes."""

import argparse
from collections import Counter
import csv
from decimal import Decimal, InvalidOperation, ROUND_HALF_UP
from pathlib import Path
import re


SCENARIOS = ("48v", "72v")
CENT = Decimal(".01")
TARGET = Decimal("5000")
CONTINGENCY = Decimal(".20")
ROOT = Path(__file__).resolve().parents[4]
MULTI_SCOPE_CATEGORY_LINKS = {
    "Structure and running gear": (
        ("Structure", "frame"),
        ("running gear", "running-gear"),
    ),
    "Power cables and electronics": (
        ("Power cables", "cables-connectors"),
        ("electronics", "electronics"),
    ),
}


def read_csv(path):
    with path.open(newline="", encoding="utf-8") as stream:
        rows = list(csv.DictReader(stream))
    if not rows or any(None in row or any(v is None or not v.strip() for v in row.values())
                       for row in rows):
        raise ValueError(f"Empty or malformed CSV: {path}")
    return rows


def number(value):
    result = Decimal(value)
    if not result.is_finite() or result < 0:
        raise ValueError(f"Invalid nonnegative number: {value}")
    return result


def money(value):
    return f"€{value:,.2f}" if value else "N/A"


def select_ids(expression):
    ids = []
    for part in expression.split("|"):
        if ":" not in part:
            ids.append(part)
            continue
        start, end = part.split(":")
        prefix, first = start.rsplit("-", 1)
        last_prefix, last = end.rsplit("-", 1)
        if prefix != last_prefix or int(first) > int(last):
            raise ValueError(f"Invalid item range: {part}")
        ids.extend(f"{prefix}-{i:03}" for i in range(int(first), int(last) + 1))
    return ids


def load(base):
    rows = read_csv(base / "chassis-bom.csv")
    ids = [row["item_id"] for row in rows]
    if len(ids) != len(set(ids)):
        raise ValueError("Duplicate ledger item ID")
    sources = set(re.findall(r"^### ([SU]\d+)$", (base / "bom/sources.md").read_text(), re.M))
    for row in rows:
        if not set(row["source_ids"].split("|")) <= sources:
            raise ValueError(f"Unknown source for {row['item_id']}")
        q1, q2 = number(row["qty_stage_1"]), number(row["qty_stage_2_total"])
        if q1 > q2 or q2 <= 0:
            raise ValueError(f"Invalid cumulative quantity: {row['item_id']}")
        for scenario in SCENARIOS:
            unit, extended = row[f"unit_eur_{scenario}"], row[f"extended_eur_{scenario}"]
            basis = row[f"basis_{scenario}"]
            if basis in ("I", "R"):
                if unit != "N/A" or extended != "N/A":
                    raise ValueError(f"Expected explained N/A for {row['item_id']}")
            elif basis not in ("A", "C") or unit == "N/A" or extended == "N/A":
                raise ValueError(f"Missing purchase price: {row['item_id']}")
            elif number(unit) <= 0 or number(extended) != (number(unit) * q2).quantize(
                    CENT, rounding=ROUND_HALF_UP):
                raise ValueError(f"Invalid extension: {row['item_id']} / {scenario}")
    modules = read_csv(base / "bom/cost-modules.csv")
    module_ids = [module["module_id"] for module in modules]
    coverage = Counter(item for module in modules for item in select_ids(module["items"]))
    if len(module_ids) != len(set(module_ids)) or set(coverage) != set(ids) or any(
            count != 1 for count in coverage.values()):
        raise ValueError("Module coverage must own every ledger item exactly once")
    for module in modules:
        if module["disposition"] not in ("installed", "bench", "support"):
            raise ValueError(f"Invalid disposition: {module['module_id']}")
        path = base / "bom" / f"{module['scope']}.md"
        if path.parent != base / "bom" or not path.is_file():
            raise ValueError(f"Invalid scope: {module['scope']}")
    return rows, modules


def total(rows, scenario, stage=False):
    return sum((number(row[f"unit_eur_{scenario}"]) * number(row["qty_stage_1"])
                if stage else number(row[f"extended_eur_{scenario}"])
                for row in rows if row[f"unit_eur_{scenario}"] != "N/A"), Decimal(0))


def table(title):
    return [f"| {title} | 48 V / 2 kW | 72 V / 4 kW |", "| --- | ---: | ---: |"]


def cost_row(label, rows):
    return f"| {label} | " + " | ".join(money(total(rows, s)) for s in SCENARIOS) + " |"


def category_label(category, category_modules):
    scopes = tuple(dict.fromkeys(module["scope"] for module in category_modules))
    links = MULTI_SCOPE_CATEGORY_LINKS.get(category)
    if links is None:
        if len(scopes) != 1:
            raise ValueError(f"Category needs explicit scope links: {category}")
        links = ((category, scopes[0]),)
    elif set(scope for _, scope in links) != set(scopes):
        raise ValueError(f"Category scope links do not match modules: {category}")
    linked_names = " and ".join(
        f"[{label}](bom/{scope}.md#document-overview)" for label, scope in links
    )
    return f"**{linked_names}**"


def block(text, name, content):
    begin, end = f"<!-- BEGIN GENERATED: {name} -->", f"<!-- END GENERATED: {name} -->"
    if text.count(begin) != 1 or text.count(end) != 1 or text.index(begin) > text.index(end):
        raise ValueError(f"Missing or ambiguous generated block: {name}")
    start, stop = text.index(begin), text.index(end) + len(end)
    return text[:start] + begin + "\n" + content + "\n" + end + text[stop:]


def render(base):
    rows, modules = load(base)
    items = {row["item_id"]: row for row in rows}
    groups = {m["module_id"]: [items[i] for i in select_ids(m["items"])] for m in modules}
    main = base / "chassis-bom.md"
    text = main.read_text()
    categories = dict.fromkeys(m["category"] for m in modules)
    overview = table("Module")
    for category in categories:
        category_modules = [module for module in modules if module["category"] == category]
        selected = [row for module in modules if module["category"] == category
                    for row in groups[module["module_id"]]]
        overview.append(cost_row(category_label(category, category_modules), selected))
    overview.append(cost_row("**All listed materials/equipment**", rows))
    text = block(text, "overview", "\n".join(overview))
    summary = []
    for category in categories:
        summary.extend([f"### {category}", "", *table("Module / detailed BOM")])
        category_rows = []
        for module in (m for m in modules if m["category"] == category):
            category_rows.extend(groups[module["module_id"]])
            link = f"[{module['label']}](bom/{module['scope']}.md#cost-{module['module_id']})"
            summary.append(cost_row(link, groups[module["module_id"]]))
            if module["module_id"] == "packs":
                summary.append("| [BMS: included in pack; not separately priced](bom/batteries.md#cost-packs) | N/A - included | N/A - included |")
        summary.append(cost_row(f"**{category} subtotal**", category_rows))
        summary.append("")
    summary.extend(["### Purchase totals", "", *table("Accounting scope")])
    for disposition, label in [("installed", "Installed-machine materials"),
                                ("bench", "Reusable bench equipment"),
                                ("support", "Loose handling / consumables / support")]:
        selected = [r for m in modules if m["disposition"] == disposition
                    for r in groups[m["module_id"]]]
        summary.append(cost_row(f"**{label}**", selected))
    summary.append(cost_row("**All listed materials/equipment**", rows))
    summary.append("| Above €5,000 materials/equipment target | " + " | ".join(
        money(max(Decimal(0), total(rows, s) - TARGET)) for s in SCENARIOS) + " |")
    phases = table("Acquisition phase")
    for label, values in [
        ("Stage 1: one-drive bench", [total(rows, s, True) for s in SCENARIOS]),
        ("Stage 2: additional purchases only", [total(rows, s) - total(rows, s, True) for s in SCENARIOS]),
        ("**Cumulative Stage 1-2**", [total(rows, s) for s in SCENARIOS]),
    ]:
        phases.append(f"| {label} | " + " | ".join(map(money, values)) + " |")
    text = block(text, "phases", "\n".join(phases))
    readiness = table("Cost basis: lines / EUR")
    for basis, label in [("C", "Calculated public-price references"), ("A", "Engineering allowances"),
                         ("I", "Included / no separate purchase"), ("R", "Reused inventory")]:
        cells = []
        for scenario in SCENARIOS:
            selected = [r for r in rows if r[f"basis_{scenario}"] == basis]
            cells.append(f"{len(selected)} / {money(total(selected, scenario))}" if selected else "N/A - no lines")
        readiness.append(f"| {label} ({basis}) | " + " | ".join(cells) + " |")
    readiness.append(cost_row(f"**Total ({len(rows)} lines)**", rows))
    text = block(text, "readiness", "\n".join(readiness))
    allowances = read_csv(base / "bom/budget-allowances.csv")
    budget = table("Budget line")
    budget.append(cost_row("Materials/equipment", rows))
    before = [total(rows, s) for s in SCENARIOS]
    for allowance in allowances:
        values = [number(allowance[f"eur_{s}"]) for s in SCENARIOS]
        before = [a + b for a, b in zip(before, values)]
        budget.append(f"| {allowance['label']} | " + " | ".join(map(money, values)) + " |")
    budget.append("| Owner fabrication labor | N/A - owner supplied | N/A - owner supplied |")
    reserve = [(v * CONTINGENCY).quantize(CENT, rounding=ROUND_HALF_UP) for v in before]
    for label, values in [
        ("**Budget before contingency**", before), ("Uncertainty contingency (20%)", reserve),
        ("**Indicative build budget**", [a + b for a, b in zip(before, reserve)]),
    ]:
        budget.append(f"| {label} | " + " | ".join(map(money, values)) + " |")
    text = block(text, "budget", "\n".join(budget))
    alternatives = read_csv(base / "bom/propulsion-alternatives.csv")
    alt_lines = ["| Alternative (excluded from totals) | Unit reference | Cumulative reference |",
                 "| --- | ---: | ---: |"]
    for alt in alternatives:
        unit = (number(alt["source_unit_price"]) / number(alt["fx_usd_per_eur"])
                * (1 + number(alt["assumed_vat_percent"]) / 100)).quantize(CENT, rounding=ROUND_HALF_UP)
        extended = unit * number(alt["qty_stage_2_total"])
        if unit != number(alt["unit_eur_reference"]) or extended != number(alt["extended_eur_reference"]):
            raise ValueError(f"Invalid alternative extension: {alt['candidate_id']}")
        if alt["replaces_item_id"] not in items or alt["source_currency"] != "USD":
            raise ValueError(f"Invalid alternative reference: {alt['candidate_id']}")
        label = f"[{alt['candidate_id']}: {alt['description']}](bom/propulsion-alternatives.csv)"
        alt_lines.append(f"| {label} | {money(unit)} | {money(extended)} |")
    text = block(text, "alternatives", "\n".join(alt_lines))
    breakdown = base / "cost-breakdown.md"
    breakdown_text = block(breakdown.read_text(), "overview", "\n".join(overview))
    breakdown_text = block(breakdown_text, "modules", "\n".join(summary))
    outputs = {main: text, breakdown: breakdown_text}
    for scope in dict.fromkeys(m["scope"] for m in modules):
        path = base / "bom" / f"{scope}.md"
        detail = ["Generated from the [cost ledger](../chassis-bom.csv).",
                  "Quantities are cumulative Stage 2; prices are line totals, not unit prices.",
                  "C = calculated reference; A = allowance; I = included; R = reused.",
                  "N/A never means an unknown purchase is free.", ""]
        owned = []
        for module in (m for m in modules if m["scope"] == scope):
            selected = groups[module["module_id"]]
            owned.extend(selected)
            detail.extend([f"### Cost: {module['module_id']}", "", f"**{module['label']}**", "",
                           "| Item / cumulative quantity | 48 V total / basis | 72 V total / basis |",
                           "| --- | ---: | ---: |"])
            for row in selected:
                label = f"{row['item_id']} - {row['description']} ({row['qty_stage_2_total']} {row['unit']})"
                cells = [f"{row[f'extended_eur_{s}'] if row[f'extended_eur_{s}'] == 'N/A' else money(number(row[f'extended_eur_{s}']))} / {row[f'basis_{s}']}"
                         for s in SCENARIOS]
                detail.append(f"| {label} | " + " | ".join(cells) + " |")
            detail.extend([cost_row("**Module subtotal**", selected), ""])
        detail.extend(table("Scope total"))
        detail.append(cost_row("**All items owned by this scope**", owned))
        outputs[path] = block(path.read_text(), "details", "\n".join(detail))
    return outputs


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=ROOT)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    try:
        outputs = render(args.root / "docs/engineering")
        stale = [path for path, text in outputs.items() if path.read_text() != text]
        if args.check and stale:
            raise ValueError("Stale BOM tables: " + ", ".join(str(p) for p in stale))
        if not args.check:
            for path in stale:
                path.write_text(outputs[path], encoding="utf-8")
        print(f"BOM tables {'checked' if args.check else 'updated'}: {len(outputs)} documents")
    except (ValueError, KeyError, InvalidOperation, OSError, ZeroDivisionError) as error:
        parser.exit(1, f"BOM error: {error}\n")


if __name__ == "__main__":
    main()
