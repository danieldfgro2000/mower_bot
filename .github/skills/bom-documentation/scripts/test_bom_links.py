"""Live link checks for every engineering Markdown document."""

from pathlib import Path
import shutil
import subprocess
import unittest


ROOT = Path(__file__).resolve().parents[4]
ENGINEERING_DOCS = ROOT / "docs/engineering"
CHECKER = "markdown-link-check@3.13.7"


class BomDocumentationLinkTest(unittest.TestCase):
    def test_every_engineering_markdown_reference_resolves(self):
        self.assertIsNotNone(shutil.which("npx"), "npx is required for BOM link checks")
        documents = sorted(ENGINEERING_DOCS.rglob("*.md"))
        self.assertTrue(documents, f"No Markdown documents found under {ENGINEERING_DOCS}")

        for document in documents:
            with self.subTest(document=document.relative_to(ROOT)):
                result = subprocess.run(
                    ["npx", "-y", CHECKER, "--quiet", str(document)],
                    capture_output=True,
                    text=True,
                    timeout=180,
                )
                self.assertEqual(
                    result.returncode,
                    0,
                    f"{document.relative_to(ROOT)} has a broken reference:\n"
                    f"{result.stdout}{result.stderr}",
                )


if __name__ == "__main__":
    unittest.main()
