"""Regression tests for the generated engineering presentation."""

import json
from pathlib import Path
import shutil
import tempfile
import unittest

from presentation import render


ROOT = Path(__file__).resolve().parents[4]
ENGINEERING = ROOT / "docs/engineering"


class PresentationTest(unittest.TestCase):
    def test_pitch_and_component_cards_use_manifest_routes_and_sources(self):
        outputs = render(ENGINEERING)
        pitch = outputs[ENGINEERING / "presentation/README.md"]
        parts = outputs[ENGINEERING / "presentation/parts.md"]
        self.assertIn("Interactive 3D viewer", pitch)
        self.assertIn("200 × 72 × 40", parts)
        self.assertIn("€119.27", parts)
        self.assertIn("206 mm diameter × 126 mm length", parts)
        self.assertIn("DC HOUSE EU/non-DE bundle", parts)
        config = json.loads(
            (ENGINEERING / "presentation/viewer/components.json").read_text()
        )
        for component in config["components"]:
            self.assertIn(f'<a id="{component["id"]}"></a>', parts)
        self.assertIn("2055-Rubber-tracks-for-miniexcavators-200x72x40", parts)
        self.assertIn("../technical/modules/01-structure-and-running-gear/running-gear.md#pod-fit-cad-assumptions", parts)

    def test_missing_technical_evidence_rejects_stale_pitch_fact(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            shutil.copytree(ENGINEERING, root / "docs/engineering")
            engineering = root / "docs/engineering"
            path = engineering / "technical/modules/01-structure-and-running-gear/running-gear.md"
            text = path.read_text()
            path.write_text(text.replace("EUR119.27 | EUR110.92", "EUR119.28 | EUR110.92", 1))
            with self.assertRaisesRegex(ValueError, "Stale presentation"):
                render(engineering)


if __name__ == "__main__":
    unittest.main()
