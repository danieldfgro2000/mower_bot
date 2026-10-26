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

    def test_summary_links_and_existing_totals(self):
        self.run_generator()
        self.run_generator("--check")
        text = (self.engineering / "chassis-bom.md").read_text()
        self.assertLess(
            text.index("<!-- BEGIN GENERATED: overview -->"),
            text.index("<!-- BEGIN GENERATED: budget -->"),
        )
        for expected in [
            "€18,322.82", "€20,611.48", "€23,343.38", "€26,689.78",
            "| **Drive train** | €3,781.66 | €3,520.00 |",
            "bom/propulsion.md#cost-motors", "bom/batteries.md#cost-chargers",
            "bom/cables-connectors.md#cost-power-cables",
            "bom/electronics.md#cost-drive-sensors", "BMS: included in pack",
            "ALT-DRV-001", "€482.36",
            "| **Drive train subtotal** | €3,781.66 | €3,520.00 |",
        ]:
            self.assertIn(expected, text)
        breakdown = (self.engineering / "cost-breakdown.md").read_text()
        self.assertIn("| **Drive train** | €3,781.66 | €3,520.00 |", breakdown)
        self.assertIn("bom/propulsion.md#cost-motors", breakdown)
        cable_doc = (self.engineering / "bom/cables-connectors.md").read_text()
        self.assertIn("PWR-008", cable_doc)
        self.assertIn("€90.00", cable_doc)
        self.assertIn("PS23: High-current harness", cable_doc)

    def test_cost_change_updates_scope_module_and_overall_totals(self):
        self.change_row("chassis-bom.csv", "PWR-008",
                        unit_eur_48v="10.00", extended_eur_48v="100.00")
        self.run_generator()
        text = (self.engineering / "chassis-bom.md").read_text()
        self.assertIn("€18,332.82", text)
        self.assertIn("€23,355.38", text)
        self.assertIn(
            "| **Power cables and electronics** | €1,689.00 | €1,679.00 |",
            text,
        )
        self.assertIn(
            "| **Power cables and electronics** | €1,689.00 | €1,679.00 |",
            (self.engineering / "cost-breakdown.md").read_text(),
        )
        self.assertIn("€100.00", (self.engineering / "bom/cables-connectors.md").read_text())
        self.assertIn("€20,611.48", text)

    def test_check_detects_stale_tables_without_writing(self):
        self.run_generator()
        path = self.engineering / "chassis-bom.md"
        before = path.read_text()
        self.change_row("chassis-bom.csv", "PWR-008",
                        unit_eur_48v="10.00", extended_eur_48v="100.00")
        self.assertIn("stale", self.run_generator("--check", success=False).stderr.lower())
        self.assertEqual(path.read_text(), before)

    def test_rejects_missing_price_and_incorrect_extensions(self):
        self.change_row("chassis-bom.csv", "PWR-008", unit_eur_48v="N/A")
        self.run_generator(success=False)
        self.change_row("chassis-bom.csv", "PWR-008", unit_eur_48v="10.00")
        self.assertIn("extension", self.run_generator(success=False).stderr.lower())

    def test_rejects_unmapped_items_before_writing(self):
        self.change_row("chassis-bom.csv", "PWR-008", item_id="PWR-099")
        self.assertIn("coverage", self.run_generator(success=False).stderr.lower())

    def test_alternative_updates_without_entering_baseline(self):
        self.change_row("bom/propulsion-alternatives.csv", "ALT-DRV-001",
                        source_unit_price="500.00", unit_eur_reference="540.76",
                        extended_eur_reference="1081.52")
        self.run_generator()
        text = (self.engineering / "chassis-bom.md").read_text()
        self.assertIn("€540.76", text)
        self.assertIn("€18,322.82", text)

    def test_missing_markers_fail_without_partial_updates(self):
        self.run_generator()
        main = self.engineering / "chassis-bom.md"
        before = main.read_text()
        scope = self.engineering / "bom/batteries.md"
        scope.write_text(scope.read_text().replace("<!-- END GENERATED: details -->", ""))
        self.change_row("chassis-bom.csv", "PWR-008",
                        unit_eur_48v="10.00", extended_eur_48v="100.00")
        self.assertIn("block", self.run_generator(success=False).stderr.lower())
        self.assertEqual(main.read_text(), before)

    def test_duplicate_module_ownership_is_rejected(self):
        path = self.engineering / "bom/cost-modules.csv"
        text = path.read_text().replace("PWR-008,Power", "PWR-008|PWR-009,Power")
        self.assertNotEqual(text, path.read_text())
        path.write_text(text)
        self.assertIn("coverage", self.run_generator(success=False).stderr.lower())


if __name__ == "__main__":
    unittest.main()
