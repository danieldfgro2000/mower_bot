"""Regression checks for linked BOM cost generation (standard library only)."""

import csv
from pathlib import Path
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
            "[ALT-DRV-001: Golden Motor HPM5000B bare motor 48 V advertised 5 kW]"
            "(propulsion-alternatives.csv)",
            main,
        )
        breakdown = (self.engineering / "cost-breakdown.md").read_text()
        self.assertIn(
            "[02.01 Traction motors and included planetary where applicable]"
            "(modules/02-drive-train/propulsion.md#cost-motors)",
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
            "€18,322.82", "€20,611.48", "€23,343.38", "€26,689.78",
            "| **[02 — Drive train](../modules/02-drive-train/propulsion.md)** | €3,781.66 | €3,520.00 |",
            "| **[01 — Structure](../modules/01-structure-and-running-gear/frame.md) and [01 — Running gear](../modules/01-structure-and-running-gear/running-gear.md)** | €2,213.00 | Same as 48 V |",
            "| **[05 — Power cables](../modules/05-power-cables-and-electronics/cables-connectors.md) and [05 — Power distribution](../modules/05-power-cables-and-electronics/power-distribution.md)** | €1,679.00 | Same as 48 V |",
            "ALT-DRV-001", "€482.36",
        ]:
            self.assertIn(expected, text)
        self.assertNotIn("modules/01-structure-and-running-gear/frame.md#document-overview", text)
        self.assertIn(
            "| DIY fabrication/printing energy | €30.00 | Same as 48 V |",
            text,
        )
        self.assertIn(
            "| Reused inventory (R) | 1 / N/A | Same as 48 V |",
            text,
        )
        self.assertIn(
            "| Acquisition stage | 48 V / 2 kW | 72 V / 4 kW |",
            text,
        )
        self.assertIn(
            "| Stage 1 — bench propulsion prototype | €9,240.91 | €10,385.24 |",
            text,
        )
        self.assertIn(
            "| Stage 2 — rolling two-pod chassis (additional purchases only) | €9,081.91 | €10,226.24 |",
            text,
        )
        self.assertIn(
            "| **Stages 1–2 cumulative** | €18,322.82 | €20,611.48 |",
            text,
        )
        self.assertNotIn("<!-- BEGIN GENERATED: modules -->", text)
        self.assertNotIn("../modules/02-drive-train/propulsion.md#cost-motors", text)
        breakdown = (self.engineering / "cost-breakdown.md").read_text()
        self.assertIn(
            "| **[02 — Drive train](modules/02-drive-train/propulsion.md)** | €3,781.66 | €3,520.00 |",
            breakdown,
        )
        self.assertIn(
            "| **[01 — Structure](modules/01-structure-and-running-gear/frame.md) and [01 — Running gear](modules/01-structure-and-running-gear/running-gear.md)** | €2,213.00 | Same as 48 V |",
            breakdown,
        )
        self.assertIn("modules/02-drive-train/propulsion.md#cost-motors", breakdown)
        self.assertIn("modules/04-battery-and-charging/batteries.md#cost-chargers", breakdown)
        self.assertIn("| **02 — Drive train subtotal** | €3,781.66 | €3,520.00 |", breakdown)
        self.assertIn(
            "| [04.02 Battery enclosures restraints and insulation](modules/04-battery-and-charging/batteries.md#cost-battery-housing) | €270.00 | Same as 48 V |",
            breakdown,
        )
        self.assertIn(
            "| [02.04 Output hubs shafts and bearings](modules/02-drive-train/propulsion.md#cost-output-support) | €210.00 | Same as 48 V |",
            breakdown,
        )
        self.assertIn(
            "| **Reusable bench equipment** | €3,720.00 | Same as 48 V |",
            breakdown,
        )
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
        self.assertIn("PS28: Independent stopping and remote control", safety_doc)
        self.assertIn("SAF-001", safety_doc)
        self.assertNotIn("PWR-001", safety_doc)
        running_gear = (self.engineering / "modules/01-structure-and-running-gear/running-gear.md").read_text()
        self.assertIn(
            "| Item / cumulative quantity | Total / basis (both variants) |",
            running_gear,
        )
        self.assertIn("| Scope total | Total (both variants) |", running_gear)
        self.assertNotIn(
            "| Item / cumulative quantity | 48 V total / basis | 72 V total / basis |",
            running_gear,
        )
        structure = breakdown.split("### 01 — Structure and running gear", 1)[1].split(
            "### 02 — Drive train", 1
        )[0]
        self.assertIn(
            "| Module / detailed BOM | Total (both variants) |",
            structure,
        )
        self.assertIn(
            "| **01 — Structure and running gear subtotal** | €2,213.00 |",
            structure,
        )
        self.assertNotIn("€2,213.00 | €2,213.00", structure)
        self.assertIn(
            "| Module / detailed BOM | 48 V / 2 kW | 72 V / 4 kW |",
            breakdown.split("### 02 — Drive train", 1)[1].split("### 03 — Width adjustment", 1)[0],
        )
        batteries = (self.engineering / "modules/04-battery-and-charging/batteries.md").read_text()
        housing = batteries.split("### Cost: battery-housing", 1)[1].split(
            "### Cost: chargers", 1
        )[0]
        self.assertIn(
            "| Item / cumulative quantity | Total / basis (both variants) |",
            housing,
        )
        self.assertIn(
            "| Item / cumulative quantity | 48 V total / basis | 72 V total / basis |",
            batteries.split("### Cost: packs", 1)[1].split("### Cost: battery-housing", 1)[0],
        )
        propulsion = (self.engineering / "modules/02-drive-train/propulsion.md").read_text()
        self.assertIn(
            "| DRV-012 - Keys bushes and reduction fasteners (2 pod set) | €30.00 / A | Same as 48 V |",
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
            "| [01.01 Rubber tracks](modules/01-structure-and-running-gear/running-gear.md#cost-tracks) |",
            breakdown,
        )
        self.assertIn(
            "| [01.04 Frame stock and mounting plates](modules/01-structure-and-running-gear/frame.md#cost-frame-stock) |",
            breakdown,
        )
        self.assertIn("**01.01 Rubber tracks**", running_gear)
        self.assertIn("**02.01 Traction motors and included planetary where applicable**", propulsion)

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
        self.assertIn("€18,332.82", text)
        self.assertIn("€23,355.38", text)
        self.assertIn(
            "| **[05 — Power cables](../modules/05-power-cables-and-electronics/cables-connectors.md) and [05 — Power distribution](../modules/05-power-cables-and-electronics/power-distribution.md)** | €1,689.00 | €1,679.00 |",
            text,
        )
        self.assertIn(
            "| **[05 — Power cables](modules/05-power-cables-and-electronics/cables-connectors.md) and [05 — Power distribution](modules/05-power-cables-and-electronics/power-distribution.md)** | €1,689.00 | €1,679.00 |",
            (self.engineering / "cost-breakdown.md").read_text(),
        )
        self.assertIn("€100.00", (self.engineering / "modules/05-power-cables-and-electronics/cables-connectors.md").read_text())
        self.assertIn("€20,611.48", text)

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
        self.change_row("bom/propulsion-alternatives.csv", "ALT-DRV-001",
                        source_unit_price="500.00", unit_eur_reference="540.76",
                        extended_eur_reference="1081.52")
        self.run_generator()
        text = (self.engineering / "bom/chassis-bom.md").read_text()
        self.assertIn("€540.76", text)
        self.assertIn("€18,322.82", text)

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
