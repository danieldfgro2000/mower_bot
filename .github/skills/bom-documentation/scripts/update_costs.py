"""Generate linked BOM tables from the CSV owners; --check never writes."""

import argparse
from collections import Counter
import csv
from decimal import Decimal, InvalidOperation, ROUND_HALF_UP
from pathlib import Path
import re


CENT = Decimal(".01")
TARGET = Decimal("5000")
CONTINGENCY = Decimal(".20")
ROOT = Path(__file__).resolve().parents[4]
MULTI_SCOPE_CATEGORY_LINKS = {
    "01 — Structure and running gear": (
        ("01 — Structure", "01-structure-and-running-gear/frame"),
        ("01 — Running gear", "01-structure-and-running-gear/running-gear"),
    ),
    "05 — Power cables and electronics": (
        ("05 — Power cables", "05-power-cables-and-electronics/cables-connectors"),
        ("05 — Power distribution", "05-power-cables-and-electronics/power-distribution"),
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
    rows = read_csv(base / "bom/chassis-bom.csv")
    ids = [row["item_id"] for row in rows]
    if len(ids) != len(set(ids)):
        raise ValueError("Duplicate ledger item ID")
    sources = Counter()
    for document in [base / "bom/sources.md", *sorted((base / "modules").glob("*/*.md"))]:
        sources.update(re.findall(
            r"^### ([SU]\d+)(?:: [^\n]+)?$", document.read_text(), re.M,
        ))
    duplicates = sorted(source for source, count in sources.items() if count > 1)
    if duplicates:
        raise ValueError(f"Duplicate source entry: {', '.join(duplicates)}")
    for row in rows:
        if not set(row["source_ids"].split("|")) <= set(sources):
            raise ValueError(f"Unknown source for {row['item_id']}")
        q1, q2 = number(row["qty_stage_1"]), number(row["qty_stage_2_total"])
        if q1 > q2 or q2 <= 0:
            raise ValueError(f"Invalid cumulative quantity: {row['item_id']}")
        unit, extended = row["unit_eur_48v"], row["extended_eur_48v"]
        basis = row["basis_48v"]
        if basis in ("I", "R"):
            if unit != "N/A" or extended != "N/A":
                raise ValueError(f"Expected explained N/A for {row['item_id']}")
        elif basis not in ("A", "C") or unit == "N/A" or extended == "N/A":
            raise ValueError(f"Missing purchase price: {row['item_id']}")
        elif number(unit) <= 0 or number(extended) != (number(unit) * q2).quantize(
                CENT, rounding=ROUND_HALF_UP):
            raise ValueError(f"Invalid extension: {row['item_id']} / 48v")
    modules = read_csv(base / "bom/cost-modules.csv")
    module_ids = [module["module_id"] for module in modules]
    coverage = Counter(item for module in modules for item in select_ids(module["items"]))
    if len(module_ids) != len(set(module_ids)) or set(coverage) != set(ids) or any(
            count != 1 for count in coverage.values()):
        raise ValueError("Module coverage must own every ledger item exactly once")
    category_numbers, submodule_numbers = {}, set()
    for module in modules:
        category_match = re.fullmatch(r"(\d{2}) — .+", module["category"])
        submodule_match = re.fullmatch(r"(\d{2})\.(\d{2}) .+", module["label"])
        if not category_match or not submodule_match:
            raise ValueError(f"Invalid module numbering: {module['module_id']}")
        category_number = category_match.group(1)
        submodule_number = ".".join(submodule_match.groups())
        if submodule_match.group(1) != category_number:
            raise ValueError(f"Submodule number does not match module: {module['module_id']}")
        if category_number in category_numbers and category_numbers[category_number] != module["category"]:
            raise ValueError(f"Duplicate module number: {category_number}")
        if submodule_number in submodule_numbers:
            raise ValueError(f"Duplicate submodule number: {submodule_number}")
        category_numbers[category_number] = module["category"]
        submodule_numbers.add(submodule_number)
        if module["disposition"] not in ("installed", "bench", "support"):
            raise ValueError(f"Invalid disposition: {module['module_id']}")
        scope_path = module["scope"]
        if not re.fullmatch(r"\d{2}-[a-z0-9-]+/[a-z0-9-]+", scope_path):
            raise ValueError(f"Invalid scope: {scope_path}")
        if not scope_path.startswith(f"{category_number}-"):
            raise ValueError(f"Scope does not match its numbered module folder: {scope_path}")
        path = base / "modules" / f"{scope_path}.md"
        if not path.is_file():
            raise ValueError(f"Invalid scope: {module['scope']}")
    return rows, modules


def total(rows, stage=False):
    return sum((number(row["unit_eur_48v"]) * number(row["qty_stage_1"])
                if stage else number(row["extended_eur_48v"])
                for row in rows if row["unit_eur_48v"] != "N/A"), Decimal(0))


def table(title, value_header="48 V"):
    return [f"| {title} | {value_header} |", "| --- | ---: |"]


def cost_row(label, rows):
    return value_row(label, money(total(rows)))


def value_row(label, value):
    return f"| {label} | {value} |"


def displayed_cost(row):
    value = row["extended_eur_48v"]
    return value if value == "N/A" else money(number(value))


def displayed_detail(row):
    return f"{displayed_cost(row)} / {row['basis_48v']}"


def category_label(category, category_modules, module_root):
    scopes = tuple(dict.fromkeys(module["scope"] for module in category_modules))
    links = MULTI_SCOPE_CATEGORY_LINKS.get(category)
    if links is None:
        if len(scopes) != 1:
            raise ValueError(f"Category needs explicit scope links: {category}")
        links = ((category, scopes[0]),)
    elif set(scope for _, scope in links) != set(scopes):
        raise ValueError(f"Category scope links do not match modules: {category}")
    linked_names = " and ".join(
        f"[{label}]({module_root}/{scope}.md)" for label, scope in links
    )
    return f"**{linked_names}**"


def overview_table(rows, modules, groups, module_root):
    categories = dict.fromkeys(module["category"] for module in modules)
    overview = table("Module")
    for category in categories:
        category_modules = [module for module in modules if module["category"] == category]
        selected = [row for module in category_modules
                    for row in groups[module["module_id"]]]
        overview.append(cost_row(
            category_label(category, category_modules, module_root),
            selected,
        ))
    overview.append(cost_row("**All listed materials/equipment**", rows))
    return "\n".join(overview)


def block(text, name, content):
    begin, end = f"<!-- BEGIN GENERATED: {name} -->", f"<!-- END GENERATED: {name} -->"
    if text.count(begin) != 1 or text.count(end) != 1 or text.index(begin) > text.index(end):
        raise ValueError(f"Missing or ambiguous generated block: {name}")
    start, stop = text.index(begin), text.index(end) + len(end)
    return text[:start] + begin + "\n" + content + "\n" + end + text[stop:]


def heading_id(title):
    return re.sub(r"[^\w -]", "", title.lower()).replace(" ", "-")


def specification_links(text, filename, item_ids):
    coverage, links = Counter(), {}
    for spec_id, title, expression in re.findall(
        r"^### (PS\d+): ([^\n]+)\n\n\*\*Cost-ledger coverage:\*\* ([^\n]+)$",
        text, re.M,
    ):
        if expression.startswith("None;"):
            continue
        ids = select_ids(expression)
        coverage.update(ids)
        heading = heading_id(f"{spec_id}: {title}")
        for item_id in ids:
            links[item_id] = f"{filename}#{heading}"
    if set(coverage) != set(item_ids) or any(count != 1 for count in coverage.values()):
        raise ValueError(f"Specification coverage must own each scope item exactly once: {filename}")
    return links


def render(base):
    rows, modules = load(base)
    items = {row["item_id"]: row for row in rows}
    groups = {m["module_id"]: [items[i] for i in select_ids(m["items"])] for m in modules}
    main = base / "bom/chassis-bom.md"
    text = main.read_text()
    categories = dict.fromkeys(m["category"] for m in modules)
    text = block(text, "overview", overview_table(rows, modules, groups, "../modules"))
    summary = []
    for category in categories:
        category_rows = []
        for module in (m for m in modules if m["category"] == category):
            category_rows.extend(groups[module["module_id"]])
        summary.extend([
            f"### {category}", "",
            *table("Module / detailed BOM"),
        ])
        for module in (m for m in modules if m["category"] == category):
            target = f"modules/{module['scope']}.md#{heading_id(module['label'])}"
            link = f"[{module['label']}]({target})"
            summary.append(cost_row(link, groups[module["module_id"]]))
            if module["module_id"] == "packs":
                summary.append(value_row(
                    f"[BMS: included in pack; not separately priced]({target})",
                    "N/A - included",
                ))
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
    summary.append(value_row(
        "Above €5,000 materials/equipment target",
        money(max(Decimal(0), total(rows) - TARGET)),
    ))
    phases = table("Acquisition stage")
    for label, value in [
        ("Stage 1 — bench propulsion prototype", total(rows, True)),
        ("Stage 2 — rolling two-pod chassis (additional purchases only)",
         total(rows) - total(rows, True)),
        ("**Stages 1–2 cumulative**", total(rows)),
    ]:
        phases.append(value_row(label, money(value)))
    text = block(text, "phases", "\n".join(phases))
    readiness = table("Cost basis: lines / EUR")
    for basis, label in [("C", "Calculated public-price references"), ("A", "Engineering allowances"),
                         ("I", "Included / no separate purchase"), ("R", "Reused inventory")]:
        selected = [r for r in rows if r["basis_48v"] == basis]
        value = f"{len(selected)} / {money(total(selected))}" if selected else "N/A - no lines"
        readiness.append(value_row(f"{label} ({basis})", value))
    readiness.append(cost_row(f"**Total ({len(rows)} lines)**", rows))
    text = block(text, "readiness", "\n".join(readiness))
    allowances = read_csv(base / "bom/budget-allowances.csv")
    budget = table("Budget line")
    budget.append(cost_row("Materials/equipment", rows))
    before = total(rows)
    for allowance in allowances:
        value = number(allowance["eur_48v"])
        before += value
        budget.append(value_row(allowance["label"], money(value)))
    budget.append(value_row(
        "Owner fabrication labor",
        "N/A - owner supplied",
    ))
    reserve = (before * CONTINGENCY).quantize(CENT, rounding=ROUND_HALF_UP)
    for label, value in [
        ("**Budget before contingency**", before), ("Uncertainty contingency (20%)", reserve),
        ("**Indicative build budget**", before + reserve),
    ]:
        budget.append(value_row(label, money(value)))
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
        reference = alt["technical_reference"]
        if not re.fullmatch(
            r"\.\./modules/\d{2}-[a-z0-9-]+/[a-z0-9-]+\.md#[a-z0-9-]+", reference,
        ) or not (main.parent / reference.split("#", 1)[0]).is_file():
            raise ValueError(f"Invalid alternative technical reference: {alt['candidate_id']}")
        label = f"[{alt['candidate_id']}: {alt['description']}]({reference})"
        alt_lines.append(f"| {label} | {money(unit)} | {money(extended)} |")
    text = block(text, "alternatives", "\n".join(alt_lines))
    breakdown = base / "cost-breakdown.md"
    breakdown_text = block(
        breakdown.read_text(),
        "overview",
        overview_table(rows, modules, groups, "modules"),
    )
    breakdown_text = block(breakdown_text, "modules", "\n".join(summary))
    outputs = {main: text, breakdown: breakdown_text}
    for scope in dict.fromkeys(m["scope"] for m in modules):
        path = base / "modules" / f"{scope}.md"
        scope_text = path.read_text()
        scope_modules = [m for m in modules if m["scope"] == scope]
        requirements = specification_links(
            scope_text, path.name,
            [item for module in scope_modules for item in select_ids(module["items"])],
        )
        detail = ["Generated from the [cost ledger](../../bom/chassis-bom.csv).",
                  "Quantities are cumulative Stage 2; prices are line totals, not unit prices.",
                  "Item links open the purchasing and inspection requirements.",
                  "C = calculated reference; A = allowance; I = included; R = reused.",
                  "N/A never means an unknown purchase is free.", ""]
        owned = []
        for module in scope_modules:
            selected = groups[module["module_id"]]
            owned.extend(selected)
            detail.extend([f'<a id="cost-{module["module_id"]}"></a>', "",
                           f"### {module['label']}", "",
                           *table(
                               "Item / cumulative quantity",
                               "48 V total / basis",
                           )])
            for row in selected:
                label = (
                    f"[{row['item_id']} - {row['description']}]({requirements[row['item_id']]})"
                    f" ({row['qty_stage_2_total']} {row['unit']})"
                )
                detail.append(value_row(label, displayed_detail(row)))
            detail.extend([cost_row("**Module subtotal**", selected), ""])
        detail.extend(table("Scope total"))
        detail.append(cost_row("**All items owned by this scope**", owned))
        outputs[path] = block(scope_text, "details", "\n".join(detail))
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
