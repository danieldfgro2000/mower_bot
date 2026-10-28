"""Regression checks for linked BOM cost generation (standard library only)."""

import csv
from decimal import Decimal, ROUND_HALF_UP
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile
import unittest


SCRIPT = Path(__file__).with_name("update_costs.py")
ROOT = Path(__file__).resolve().parents[4]


class CostDocumentationTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        shutil.copytree(ROOT / "docs/engineering", self.root / "docs/engineering")
        self.engineering = self.root / "docs/engineering"
        with (self.engineering / "bom/chassis-bom.csv").open() as stream:
            purchases = [row for row in csv.DictReader(stream)
                         if row["unit_eur_48v"] != "N/A"]
        self.baseline_total = sum(
            (Decimal(row["extended_eur_48v"]) for row in purchases), Decimal(0)
        )
        self.baseline_stage1 = sum(
            (Decimal(row["unit_eur_48v"]) * Decimal(row["qty_stage_1"])
             for row in purchases), Decimal(0)
        )
        with (self.engineering / "bom/budget-allowances.csv").open() as stream:
            allowances = sum(
                (Decimal(row["eur_48v"]) for row in csv.DictReader(stream)), Decimal(0)
            )
        self.baseline_budget = ((self.baseline_total + allowances) * Decimal("1.20")).quantize(
            Decimal(".01"), rounding=ROUND_HALF_UP
        )

    def run_generator(self, *args, success=True):
        self.assertTrue(SCRIPT.exists(), "Missing linked BOM cost generator")
        result = subprocess.run(
            [sys.executable, str(SCRIPT), "--root", str(self.root), *args],
            capture_output=True, text=True,
        )
        self.assertEqual(result.returncode == 0, success, result.stdout + result.stderr)
        return result

    def change_row(self, filename, target_id, **updates):
        path = self.engineering / filename
        with path.open() as stream:
            reader = csv.DictReader(stream)
            fields, rows = reader.fieldnames, list(reader)
        row = next(row for row in rows if row.get("item_id", row.get("candidate_id")) == target_id)
        row.update(updates)
        with path.open("w", newline="") as stream:
            writer = csv.DictWriter(stream, fieldnames=fields)
            writer.writeheader()
            writer.writerows(rows)

    def test_active_cost_inputs_are_48v_only(self):
        for filename in ("bom/chassis-bom.csv", "bom/budget-allowances.csv"):
            with self.subTest(filename=filename):
                with (self.engineering / filename).open() as stream:
                    fields = csv.DictReader(stream).fieldnames
                self.assertFalse(any("72v" in field for field in fields), fields)

    def test_selected_drive_components_and_battery_accounting(self):
        with (self.engineering / "bom/chassis-bom.csv").open() as stream:
            rows = {row["item_id"]: row for row in csv.DictReader(stream)}
        expected = {
            "DRV-001": ("HPM5000B", "482.36", "964.72", "S23|S24"),
            "DRV-002": ("EZ-A48500", "309.31", "618.62", "S32"),
            "DRV-003": ("FDB 13 C", "192.39", "384.78", "S33"),
        }
        for item, (model, unit, total, sources) in expected.items():
            with self.subTest(item=item):
                row = rows[item]
                self.assertIn(model, row["description"])
                self.assertEqual(row["unit_eur_48v"], unit)
                self.assertEqual(row["extended_eur_48v"], total)
                self.assertEqual(row["source_ids"], sources)
                self.assertEqual(row["qty_stage_1"], "1")
                self.assertEqual(row["qty_stage_2_total"], "2")
                self.assertEqual(row["basis_48v"], "C")
        self.assertIn("unpriced", rows["DRV-001"]["qualification_or_assumption"])
        self.assertIn("unpriced", rows["DRV-003"]["qualification_or_assumption"])
        self.assertEqual(rows["BAT-001"]["extended_eur_48v"], "2056.98")
        self.assertEqual(rows["BAT-005"]["basis_48v"], "I")
        self.assertEqual(rows["BAT-005"]["extended_eur_48v"], "N/A")
        self.assertEqual(self.baseline_total, Decimal("10584.10"))
        self.assertEqual(self.baseline_budget, Decimal("13756.92"))
        with (self.engineering / "bom/propulsion-alternatives.csv").open() as stream:
            alternatives = list(csv.DictReader(stream))
        self.assertNotIn("ALT-DRV-001", [row["candidate_id"] for row in alternatives])
        self.assertTrue(all("HPM5000B" not in row["description"] for row in alternatives))

    def test_48v_only_inputs_generate_single_scenario_tables(self):
        for filename in ("bom/chassis-bom.csv", "bom/budget-allowances.csv"):
            path = self.engineering / filename
            with path.open() as stream:
                reader = csv.DictReader(stream)
                fields = [field for field in reader.fieldnames if "72v" not in field]
                rows = list(reader)
            with path.open("w", newline="") as stream:
                writer = csv.DictWriter(stream, fieldnames=fields, extrasaction="ignore")
                writer.writeheader()
                writer.writerows(rows)
        with (self.engineering / "bom/chassis-bom.csv").open() as stream:
            expected_total = sum(
                (Decimal(row["extended_eur_48v"]) for row in csv.DictReader(stream)
                 if row["extended_eur_48v"] != "N/A"), Decimal(0)
            )
        self.run_generator()
        self.run_generator("--check")
        main = (self.engineering / "bom/chassis-bom.md").read_text()
        self.assertIn("| Module | 48 V |", main)
        self.assertIn(
            f"| **All listed materials/equipment** | €{expected_total:,.2f} |",
            main,
        )
        for path in self.engineering.rglob("*.md"):
            for name, content in re.findall(
                r"<!-- BEGIN GENERATED: ([a-z-]+) -->(.*?)<!-- END GENERATED: \1 -->",
                path.read_text(), re.S,
            ):
                with self.subTest(path=path, block=name):
                    self.assertNotIn("72 V", content)
                    self.assertNotIn("both variants", content)
                    self.assertNotIn("Same as 48 V", content)
                    if name != "alternatives":
                        for line in content.splitlines():
                            if line.startswith("|"):
                                self.assertEqual(line.count("|"), 3, line)

    def test_module_scopes_are_grouped_in_their_numbered_folders(self):
        self.run_generator()
        module_docs = {
            "01-structure-and-running-gear": ("frame.md", "running-gear.md"),
            "02-drive-train": ("propulsion.md",),
            "03-width-adjustment": ("width-adjustment.md",),
            "04-battery-and-charging": ("batteries.md",),
            "05-power-cables-and-electronics": (
                "cables-connectors.md",
                "power-distribution.md",
            ),
            "06-safety-controls-and-sensors": ("safety-controls.md",),
            "07-workshop-and-support": ("workshop.md",),
        }
        for folder, documents in module_docs.items():
            directory = self.engineering / "modules" / folder
            self.assertTrue((directory / "README.md").is_file(), folder)
            for document in documents:
                self.assertTrue((directory / document).is_file(), f"{folder}/{document}")

        self.assertTrue((self.engineering / "bom/chassis-bom.csv").is_file())
        main = (self.engineering / "bom/chassis-bom.md").read_text()
        self.assertIn(
            "[02 — Drive train](../modules/02-drive-train/propulsion.md)",
            main,
        )
        self.assertIn(
            "[ALT-DRV-002: BLDC D110BLD2000 48 V motor with planetary provision]"
            "(../modules/02-drive-train/propulsion.md"
            "#48-v--approximately-2-kw-per-drive)",
            main,
        )
        breakdown = (self.engineering / "cost-breakdown.md").read_text()
        self.assertIn(
            "[02.01 Traction motors and included planetary where applicable]"
            "(modules/02-drive-train/propulsion.md"
            "#0201-traction-motors-and-included-planetary-where-applicable)",
            breakdown,
        )

    def test_summary_links_and_existing_totals(self):
        self.run_generator()
        self.run_generator("--check")
        text = (self.engineering / "bom/chassis-bom.md").read_text()
        self.assertLess(
            text.index("<!-- BEGIN GENERATED: overview -->"),
            text.index("<!-- BEGIN GENERATED: budget -->"),
        )
        for expected in [
            f"€{self.baseline_total:,.2f}", f"€{self.baseline_budget:,.2f}",
            "| **[02 — Drive train](../modules/02-drive-train/propulsion.md)** | €2,208.12 |",
            "| **[01 — Structure](../modules/01-structure-and-running-gear/frame.md) and [01 — Running gear](../modules/01-structure-and-running-gear/running-gear.md)** | €2,213.00 |",
            "| **[05 — Power cables](../modules/05-power-cables-and-electronics/cables-connectors.md) and [05 — Power distribution](../modules/05-power-cables-and-electronics/power-distribution.md)** | €1,679.00 |",
            "ALT-DRV-002", "€1,035.94",
        ]:
            self.assertIn(expected, text)
        self.assertNotIn("modules/01-structure-and-running-gear/frame.md#document-overview", text)
        self.assertIn(
            "| DIY fabrication/printing energy | €30.00 |",
            text,
        )
        self.assertIn(
            "| Reused inventory (R) | 8 / N/A |",
            text,
        )
        self.assertIn(
            "| Acquisition stage | 48 V |",
            text,
        )
        self.assertIn(
            f"| Stage 1 — bench propulsion prototype | €{self.baseline_stage1:,.2f} |",
            text,
        )
        self.assertIn(
            "| Stage 2 — rolling two-pod chassis (additional purchases only)"
            f" | €{self.baseline_total - self.baseline_stage1:,.2f} |",
            text,
        )
        self.assertIn(
            f"| **Stages 1–2 cumulative** | €{self.baseline_total:,.2f} |",
            text,
        )
        self.assertIn("no dynamometer or direct torque measurement", text)
        self.assertIn(
            "| **[07 — Workshop and support](../modules/07-workshop-and-support/workshop.md)** | €615.00 |",
            text,
        )
        overview = text.split("<!-- BEGIN GENERATED: overview -->", 1)[1].split(
            "<!-- END GENERATED: overview -->", 1
        )[0]
        self.assertNotIn("€1,500.00 |", overview)
        self.assertNotIn("<!-- BEGIN GENERATED: modules -->", text)
        self.assertNotIn(
            "../modules/02-drive-train/propulsion.md"
            "#0201-traction-motors-and-included-planetary-where-applicable",
            text,
        )
        breakdown = (self.engineering / "cost-breakdown.md").read_text()
        self.assertIn(
            "| **[02 — Drive train](modules/02-drive-train/propulsion.md)** | €2,208.12 |",
            breakdown,
        )
        self.assertIn(
            "| **[01 — Structure](modules/01-structure-and-running-gear/frame.md) and [01 — Running gear](modules/01-structure-and-running-gear/running-gear.md)** | €2,213.00 |",
            breakdown,
        )
        self.assertIn(
            "modules/02-drive-train/propulsion.md"
            "#0201-traction-motors-and-included-planetary-where-applicable",
            breakdown,
        )
        self.assertIn(
            "modules/04-battery-and-charging/batteries.md#0403-matched-battery-chargers",
            breakdown,
        )
        self.assertNotIn(".md#cost-", breakdown)
        self.assertIn("| **02 — Drive train subtotal** | €2,208.12 |", breakdown)
        self.assertIn(
            "| [04.02 Battery enclosures restraints and insulation]"
            "(modules/04-battery-and-charging/batteries.md"
            "#0402-battery-enclosures-restraints-and-insulation) | €270.00 |",
            breakdown,
        )
        self.assertIn(
            "| [02.04 Output hubs shafts and bearings]"
            "(modules/02-drive-train/propulsion.md#0204-output-hubs-shafts-and-bearings)"
            " | €210.00 |",
            breakdown,
        )
        self.assertIn(
            "| **Reusable bench equipment** | €285.00 |",
            breakdown,
        )
        self.assertIn(
            "| **Loose handling / consumables / support** | €330.00 |",
            breakdown,
        )
        self.assertNotIn("07.03 Dynamometer", breakdown)
        self.assertNotIn("06.02 Industrial operator remote", breakdown)
        cable_doc = (self.engineering / "modules/05-power-cables-and-electronics/cables-connectors.md").read_text()
        self.assertIn("PWR-008", cable_doc)
        self.assertIn("€90.00", cable_doc)
        self.assertIn("PS23: High-current harness", cable_doc)
        power_doc = (
            self.engineering
            / "modules/05-power-cables-and-electronics/power-distribution.md"
        ).read_text()
        safety_doc = (
            self.engineering
            / "modules/06-safety-controls-and-sensors/safety-controls.md"
        ).read_text()
        self.assertIn("PWR-001", power_doc)
        self.assertNotIn("SAF-001", power_doc)
        self.assertIn("PS28: Independent stopping and normal control", safety_doc)
        self.assertIn("SAF-001", safety_doc)
        self.assertNotIn("PWR-001", safety_doc)
        running_gear = (self.engineering / "modules/01-structure-and-running-gear/running-gear.md").read_text()
        self.assertIn(
            "| Item / cumulative quantity | 48 V total / basis |",
            running_gear,
        )
        self.assertIn("| Scope total | 48 V |", running_gear)
        self.assertNotIn(
            "| Item / cumulative quantity | 48 V total / basis | 72 V total / basis |",
            running_gear,
        )
        structure = breakdown.split("### 01 — Structure and running gear", 1)[1].split(
            "### 02 — Drive train", 1
        )[0]
        self.assertIn(
            "| Module / detailed BOM | 48 V |",
            structure,
        )
        self.assertIn(
            "| **01 — Structure and running gear subtotal** | €2,213.00 |",
            structure,
        )
        self.assertNotIn("€2,213.00 | €2,213.00", structure)
        self.assertIn(
            "| Module / detailed BOM | 48 V |",
            breakdown.split("### 02 — Drive train", 1)[1].split("### 03 — Width adjustment", 1)[0],
        )
        batteries = (self.engineering / "modules/04-battery-and-charging/batteries.md").read_text()
        self.assertIn('<a id="cost-battery-housing"></a>', batteries)
        housing = batteries.split('<a id="cost-battery-housing"></a>', 1)[1].split(
            '<a id="cost-chargers"></a>', 1
        )[0]
        self.assertIn(
            "| Item / cumulative quantity | 48 V total / basis |",
            housing,
        )
        self.assertIn(
            "| Item / cumulative quantity | 48 V total / basis |",
            batteries.split('<a id="cost-packs"></a>', 1)[1].split(
                '<a id="cost-battery-housing"></a>', 1
            )[0],
        )
        propulsion = (self.engineering / "modules/02-drive-train/propulsion.md").read_text()
        self.assertIn(
            "| [DRV-012 - Keys bushes and reduction fasteners]"
            "(propulsion.md#ps17-reduction-and-transmission-hardware)"
            " (2 pod set) | €30.00 / A |",
            propulsion,
        )

    def test_module_and_submodule_numbers_follow_module_map(self):
        self.run_generator()
        main = (self.engineering / "bom/chassis-bom.md").read_text()
        breakdown = (self.engineering / "cost-breakdown.md").read_text()
        running_gear = (self.engineering / "modules/01-structure-and-running-gear/running-gear.md").read_text()
        propulsion = (self.engineering / "modules/02-drive-train/propulsion.md").read_text()

        self.assertIn(
            "| **[01 — Structure](../modules/01-structure-and-running-gear/frame.md) and "
            "[01 — Running gear](../modules/01-structure-and-running-gear/running-gear.md)** |",
            main,
        )
        self.assertIn("| **[02 — Drive train](../modules/02-drive-train/propulsion.md)** |", main)
        self.assertIn("### 01 — Structure and running gear", breakdown)
        self.assertIn(
            "| [01.01 Rubber tracks]"
            "(modules/01-structure-and-running-gear/running-gear.md#0101-rubber-tracks) |",
            breakdown,
        )
        self.assertIn(
            "| [01.04 Frame stock and mounting plates]"
            "(modules/01-structure-and-running-gear/frame.md#0104-frame-stock-and-mounting-plates) |",
            breakdown,
        )
        self.assertIn('<a id="cost-tracks"></a>\n\n### 01.01 Rubber tracks', running_gear)
        self.assertIn("### 02.01 Traction motors and included planetary where applicable", propulsion)
        self.assertNotIn("### Cost: ", running_gear)
        self.assertNotIn("### Cost: ", propulsion)

    def test_every_cost_item_links_to_its_named_specification(self):
        self.run_generator()
        with (self.engineering / "bom/chassis-bom.csv").open() as stream:
            expected = {row["item_id"] for row in csv.DictReader(stream)}
        linked = []
        for path in (self.engineering / "modules").rglob("*.md"):
            for item_id, target in re.findall(
                r"\[([A-Z]+-\d+) - [^\]]+\]\(([^)]+#ps\d+[^)]+)\)",
                path.read_text(),
            ):
                linked.append(item_id)
                self.assertTrue(target.startswith(f"{path.name}#"), target)
        self.assertCountEqual(linked, expected)
        tools = (
            self.engineering / "modules/07-workshop-and-support/workshop.md"
        ).read_text()
        self.assertIn(
            "[TST-010 - DC-capable clamp meter]"
            "(workshop.md#ps36-instruments-and-workshop-tools) (1 each)",
            tools,
        )

    def test_descriptive_source_headings_preserve_source_ids(self):
        path = self.engineering / "bom/sources.md"
        path.write_text(re.sub(
            r"^### S01(?::[^\n]+)?$",
            "### S01: PowerTrack rubber tracks",
            path.read_text(),
            flags=re.M,
        ))
        self.run_generator()
        self.run_generator("--check")

    def test_missing_or_duplicate_specification_coverage_fails_without_writes(self):
        path = self.engineering / "modules/01-structure-and-running-gear/frame.md"
        original = path.read_text()
        main = self.engineering / "bom/chassis-bom.md"
        before = main.read_text()
        for coverage in ("CHS-008:CHS-009", "CHS-001:CHS-009"):
            with self.subTest(coverage=coverage):
                path.write_text(original.replace("CHS-007:CHS-009", coverage))
                result = self.run_generator(success=False)
                self.assertIn("specification coverage", result.stderr.lower())
                self.assertEqual(main.read_text(), before)

    def test_rejects_submodule_number_outside_its_parent_module(self):
        path = self.engineering / "bom/cost-modules.csv"
        path.write_text(
            path.read_text().replace("tracks,01.01 ", "tracks,02.01 ", 1),
        )
        self.assertIn(
            "number",
            self.run_generator(success=False).stderr.lower(),
        )

    def test_scope_document_must_live_under_its_numbered_module_folder(self):
        path = self.engineering / "bom/cost-modules.csv"
        path.write_text(
            path.read_text().replace(
                "02-drive-train/propulsion",
                "03-width-adjustment/width-adjustment",
            ),
        )
        self.assertIn(
            "module folder",
            self.run_generator(success=False).stderr.lower(),
        )

    def test_cost_change_updates_scope_module_and_overall_totals(self):
        self.change_row("bom/chassis-bom.csv", "PWR-008",
                        unit_eur_48v="10.00", extended_eur_48v="100.00")
        self.run_generator()
        text = (self.engineering / "bom/chassis-bom.md").read_text()
        self.assertIn(f"€{self.baseline_total + Decimal('10'):,.2f}", text)
        self.assertIn(f"€{self.baseline_budget + Decimal('12'):,.2f}", text)
        self.assertIn(
            "| **[05 — Power cables](../modules/05-power-cables-and-electronics/cables-connectors.md) and [05 — Power distribution](../modules/05-power-cables-and-electronics/power-distribution.md)** | €1,689.00 |",
            text,
        )
        self.assertIn(
            "| **[05 — Power cables](modules/05-power-cables-and-electronics/cables-connectors.md) and [05 — Power distribution](modules/05-power-cables-and-electronics/power-distribution.md)** | €1,689.00 |",
            (self.engineering / "cost-breakdown.md").read_text(),
        )
        self.assertIn("€100.00", (self.engineering / "modules/05-power-cables-and-electronics/cables-connectors.md").read_text())

    def test_check_detects_stale_tables_without_writing(self):
        self.run_generator()
        path = self.engineering / "bom/chassis-bom.md"
        before = path.read_text()
        self.change_row("bom/chassis-bom.csv", "PWR-008",
                        unit_eur_48v="10.00", extended_eur_48v="100.00")
        self.assertIn("stale", self.run_generator("--check", success=False).stderr.lower())
        self.assertEqual(path.read_text(), before)

    def test_rejects_missing_price_and_incorrect_extensions(self):
        self.change_row("bom/chassis-bom.csv", "PWR-008", unit_eur_48v="N/A")
        self.run_generator(success=False)
        self.change_row("bom/chassis-bom.csv", "PWR-008", unit_eur_48v="10.00")
        self.assertIn("extension", self.run_generator(success=False).stderr.lower())

    def test_rejects_unmapped_items_before_writing(self):
        self.change_row("bom/chassis-bom.csv", "PWR-008", item_id="PWR-099")
        self.assertIn("coverage", self.run_generator(success=False).stderr.lower())

    def test_alternative_updates_without_entering_baseline(self):
        self.change_row("bom/propulsion-alternatives.csv", "ALT-DRV-002",
                        source_unit_price="500.00", unit_eur_reference="540.76",
                        extended_eur_reference="1081.52")
        self.run_generator()
        text = (self.engineering / "bom/chassis-bom.md").read_text()
        self.assertIn("€540.76", text)
        self.assertIn(f"€{self.baseline_total:,.2f}", text)

    def test_missing_markers_fail_without_partial_updates(self):
        self.run_generator()
        main = self.engineering / "bom/chassis-bom.md"
        before = main.read_text()
        scope = self.engineering / "modules/04-battery-and-charging/batteries.md"
        scope.write_text(scope.read_text().replace("<!-- END GENERATED: details -->", ""))
        self.change_row("bom/chassis-bom.csv", "PWR-008",
                        unit_eur_48v="10.00", extended_eur_48v="100.00")
        self.assertIn("block", self.run_generator(success=False).stderr.lower())
        self.assertEqual(main.read_text(), before)

    def test_duplicate_module_ownership_is_rejected(self):
        path = self.engineering / "bom/cost-modules.csv"
        text = path.read_text().replace(
            "PWR-008,05 — Power", "PWR-008|PWR-009,05 — Power",
        )
        self.assertNotEqual(text, path.read_text())
        path.write_text(text)
        self.assertIn("coverage", self.run_generator(success=False).stderr.lower())


if __name__ == "__main__":
    unittest.main()
