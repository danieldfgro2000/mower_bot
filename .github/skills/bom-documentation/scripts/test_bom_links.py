"""Read-only local/fragment and live external checks for engineering Markdown."""

from html import escape
from html.parser import HTMLParser
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
import shutil
import subprocess
import tempfile
import threading
import unittest
from unittest.mock import patch
from urllib.parse import unquote, urlsplit


ROOT = Path(__file__).resolve().parents[4]
ENGINEERING_DOCS = ROOT / "docs/engineering"
CHECKER = "markdown-link-check@3.13.7"
RENDERER = Path(__file__).with_name("render_markdown.mjs")


class DocumentReferences(HTMLParser):
    def __init__(self):
        super().__init__()
        self.anchors = set()
        self.links = []

    def handle_starttag(self, tag, attrs):
        for name, value in attrs:
            if value is None:
                continue
            if name == "id" or (tag == "a" and name == "name"):
                self.anchors.add(value)
            elif name in ("href", "src"):
                self.links.append(value)


def read_document(document):
    text = document.read_text(encoding="utf-8")
    if document.suffix.lower() in (".md", ".markdown"):
        result = subprocess.run(
            ["node", str(RENDERER)], input=text, capture_output=True, text=True,
            timeout=30,
        )
        if result.returncode:
            raise RuntimeError(
                f"Markdown parser failed for {document}:\n{result.stderr}\n"
                "Install the pinned parser with: "
                "npm ci --prefix .github/skills/bom-documentation --ignore-scripts"
            )
        text = result.stdout
    parsed = DocumentReferences()
    parsed.feed(text)
    parsed.close()
    return parsed


def local_reference_errors(document, *, root=None):
    document = document.resolve()
    root = (root or document.parent).resolve()
    cache = {document: read_document(document)}
    errors, external = [], []
    for link in dict.fromkeys(cache[document].links):
        if link.startswith("#"):
            errors.append(
                f"{document.relative_to(root)}: {link} -> fragment-only navigation; "
                f"use '{document.name}{link}' to keep the document context"
            )
            continue
        url = urlsplit(link)
        if url.scheme not in ("", "file") or url.netloc:
            external.append(link)
            continue
        path = unquote(url.path)
        if url.scheme == "file":
            target = Path(path).resolve()
        elif path.startswith("/"):
            target = (root / path.lstrip("/")).resolve()
        else:
            target = (document.parent / path).resolve() if path else document
        problem = None
        if not target.is_relative_to(root):
            problem = "local target is outside the repository"
        elif not target.exists():
            problem = f"missing file '{target.relative_to(root)}'"
        elif url.fragment:
            if not target.is_file() or target.suffix.lower() not in (
                ".md", ".markdown", ".html", ".htm", ".svg",
            ):
                problem = f"cannot validate a fragment in '{target.relative_to(root)}'"
            else:
                if target not in cache:
                    cache[target] = read_document(target)
                fragment = unquote(url.fragment)
                if fragment not in cache[target].anchors:
                    problem = (
                        f"missing anchor '#{fragment}' in '{target.relative_to(root)}'"
                    )
        if problem:
            errors.append(f"{document.relative_to(root)}: {link} -> {problem}")
    return errors, external


def run_checker(document, *, root=None):
    errors, external = local_reference_errors(document, root=root)
    if errors or not external:
        return subprocess.CompletedProcess(
            [str(document)], int(bool(errors)), "", "\n".join(errors),
        )
    # Only external URLs reach the HTTP checker; its local fragment handling is incomplete.
    links = "\n".join(f'<a href="{escape(link, quote=True)}">External</a>'
                      for link in external)
    return subprocess.run(
        ["npx", "-y", CHECKER, "--quiet"],
        input=links,
        capture_output=True,
        text=True,
        timeout=180,
    )


def checker_failure(result):
    output = f"{result.stdout}\n{result.stderr}"
    return result.returncode != 0 or "[✖]" in output or "dead links found" in output


class BomReferenceRegressionTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)

    def write_document(self, name, content):
        document = self.root / name
        document.parent.mkdir(parents=True, exist_ok=True)
        document.write_text(content, encoding="utf-8")
        return document

    def test_navigation_requires_a_document_even_when_the_heading_exists(self):
        document = self.write_document(
            "batteries.md",
            "[Itemized costs](#detailed-module-costs)\n\n## Detailed module costs\n",
        )
        errors, _ = local_reference_errors(document)
        self.assertEqual(len(errors), 1, errors)
        self.assertIn("fragment-only", errors[0])
        self.assertIn("batteries.md#detailed-module-costs", errors[0])

    def test_rejects_missing_same_page_anchor(self):
        document = self.write_document(
            "chassis-bom.md", "# Chassis BOM\n\n[Drive train](#drive-train)\n",
        )
        result = run_checker(document)
        self.assertTrue(checker_failure(result), "Missing #drive-train was accepted")
        self.assertIn("#drive-train", result.stdout + result.stderr)

    def test_rejects_missing_cross_file_anchor(self):
        self.write_document("bom/propulsion.md", "# Propulsion\n\n## Motors\n")
        document = self.write_document(
            "chassis-bom.md", "[Drive train](bom/propulsion.md#drive-train)\n",
        )
        result = run_checker(document)
        self.assertTrue(
            checker_failure(result), "An existing file hid its missing #drive-train",
        )
        self.assertIn("bom/propulsion.md#drive-train", result.stdout + result.stderr)

    def test_nonrendered_headings_are_not_anchors(self):
        for heading in [
            "<!--\n## Drive train\n-->\n",
            "```md\n## Drive train\n```\n",
            "~~~md\n## Drive train\n~~~\n",
            "````md\n```\n## Drive train\n```\n````\n",
            "    ## Drive train\n",
            "`## Drive train`\n",
            "\\## Drive train\n",
        ]:
            with self.subTest(heading=heading):
                document = self.write_document(
                    "chassis-bom.md", f"[Drive train](#drive-train)\n\n{heading}",
                )
                result = run_checker(document)
                self.assertTrue(
                    checker_failure(result), "A nonrendered heading was accepted",
                )
                self.assertIn("#drive-train", result.stdout + result.stderr)

    def test_accepts_existing_same_page_and_reference_style_cross_file_anchors(self):
        self.write_document("bom/propulsion.md", "# Propulsion\n\n## Drive train\n")
        document = self.write_document(
            "chassis-bom.md",
            "## Drive train\n\n[Totals](chassis-bom.md#drive-train)\n\n"
            "[Drive details][drive]\n\n"
            '[drive]: bom/propulsion.md#drive-train "Drive details"\n',
        )
        result = run_checker(document)
        self.assertFalse(checker_failure(result), result.stdout + result.stderr)

    def test_resolves_formatted_duplicate_and_setext_headings(self):
        document = self.write_document(
            "chassis-bom.md",
            "# **Drive** `train`\n\n## Drive train\n\n## Drive train-1\n\n"
            "## Drive train\n\nBattery & charging\n------------------\n\n"
            "[First](chassis-bom.md#drive-train)\n"
            "[Second](chassis-bom.md#drive-train-1)\n"
            "[Collision](chassis-bom.md#drive-train-1-1)\n"
            "[Third](chassis-bom.md#drive-train-2)\n"
            "[Battery](chassis-bom.md#battery--charging)\n",
        )
        result = run_checker(document)
        self.assertFalse(checker_failure(result), result.stdout + result.stderr)

    def test_resolves_html_anchors_and_encoded_paths(self):
        self.write_document(
            "bom/drive details.md",
            '## Baterías\n\n<a name="legacy-costs"></a>\n\n'
            '<section id="budget">Budget details</section>\n',
        )
        document = self.write_document(
            "chassis-bom.md",
            "[Batteries](bom/drive%20details.md#bater%C3%ADas)\n"
            "[Legacy](bom/drive%20details.md#legacy-costs)\n"
            '<a href="bom/drive%20details.md#budget">Budget</a>\n',
        )
        result = run_checker(document)
        self.assertFalse(checker_failure(result), result.stdout + result.stderr)

    def test_rejects_reference_style_and_html_links_to_missing_fragments(self):
        self.write_document("bom/propulsion.md", "# Propulsion\n")
        for content in [
            "[Drive details][drive]\n\n[drive]: bom/propulsion.md#drive-train\n",
            '<a href="bom/propulsion.md#drive-train">Drive details</a>\n',
        ]:
            with self.subTest(content=content):
                document = self.write_document("chassis-bom.md", content)
                result = run_checker(document)
                self.assertTrue(checker_failure(result), "A missing fragment was accepted")
                self.assertIn("bom/propulsion.md#drive-train", result.stdout + result.stderr)

    def test_checks_local_images(self):
        document = self.write_document(
            "chassis-bom.md", "![Drive layout](missing-layout.svg)\n",
        )
        result = run_checker(document)
        self.assertTrue(checker_failure(result), "A missing diagram was accepted")
        self.assertIn("missing-layout.svg", result.stdout + result.stderr)

    def test_ignores_links_in_comments_and_code(self):
        document = self.write_document(
            "chassis-bom.md",
            "# Chassis BOM\n\n<!-- [Hidden](missing.md) -->\n\n"
            "~~~md\n[Example](missing.md)\n~~~\n\n"
            "    [Indented example](missing.md)\n\n"
            "`[Inline example](missing.md)`\n",
        )
        result = run_checker(document)
        self.assertFalse(checker_failure(result), result.stdout + result.stderr)

    def test_reports_broken_references_without_creating_files(self):
        document = self.write_document(
            "chassis-bom.md", "[Drive train](bom/missing.md#drive-train)\n",
        )
        before = document.read_bytes()
        result = run_checker(document)
        self.assertTrue(checker_failure(result))
        self.assertIn("chassis-bom.md", result.stdout + result.stderr)
        self.assertIn("bom/missing.md#drive-train", result.stdout + result.stderr)
        self.assertEqual(document.read_bytes(), before)
        self.assertFalse((self.root / "bom/missing.md").exists())

    def test_removing_actual_drive_train_heading_is_detected(self):
        shutil.copytree(ROOT / "docs/engineering", self.root / "docs/engineering")
        for relative in ("plan.md", ".github/skills/bom-documentation/SKILL.md"):
            self.write_document(relative, (ROOT / relative).read_text(encoding="utf-8"))
        document = self.root / "docs/engineering/cost-breakdown.md"
        original = "[Drive train](cost-breakdown.md#02--drive-train)\n\n" + document.read_text(
            encoding="utf-8",
        )
        document.write_text(original, encoding="utf-8")
        errors, _ = local_reference_errors(document, root=self.root)
        self.assertEqual(errors, [])
        changed = original.replace(
            "\n### 02 — Drive train\n", "\n### Removed drive section\n",
        )
        self.assertNotEqual(original, changed, "The real Drive train heading was not found")
        document.write_text(changed, encoding="utf-8")
        errors, _ = local_reference_errors(document, root=self.root)
        self.assertEqual(len(errors), 1, errors)
        self.assertIn(
            "docs/engineering/cost-breakdown.md: cost-breakdown.md#02--drive-train "
            "-> missing anchor '#02--drive-train'",
            errors[0],
        )
        self.assertEqual(document.read_text(encoding="utf-8"), changed)

    def test_repository_test_fails_for_a_missing_cross_file_fragment(self):
        self.write_document("bom/propulsion.md", "# Propulsion\n")
        self.write_document(
            "chassis-bom.md", "[Drive train](bom/propulsion.md#drive-train)\n",
        )
        with patch(f"{__name__}.ROOT", self.root), patch(
            f"{__name__}.ENGINEERING_DOCS", self.root,
        ):
            result = unittest.TestResult()
            BomDocumentationLinkTest(
                "test_every_engineering_markdown_reference_resolves",
            ).run(result)
        self.assertEqual(result.errors, [])
        self.assertEqual(len(result.failures), 1, result.failures)
        self.assertIn("chassis-bom.md", result.failures[0][1])
        self.assertIn("missing anchor '#drive-train'", result.failures[0][1])

    def test_parser_failure_is_not_accepted_as_a_broken_reference(self):
        document = self.write_document("chassis-bom.md", "[Missing](missing.md)\n")
        failure = subprocess.CompletedProcess(["node"], 1, "", "Missing parser dependency")
        with patch("subprocess.run", return_value=failure):
            with self.assertRaisesRegex(RuntimeError, "Markdown parser failed"):
                run_checker(document)

    def test_checker_diagnostics_override_a_zero_exit_status(self):
        for stdout, stderr in [
            ("[✖] https://example.invalid -> Status: 404", ""),
            ("", "ERROR: 1 dead links found"),
        ]:
            with self.subTest(stdout=stdout, stderr=stderr):
                self.assertTrue(checker_failure(
                    subprocess.CompletedProcess(["npx"], 0, stdout, stderr),
                ))
        self.assertFalse(checker_failure(subprocess.CompletedProcess(["npx"], 0, "", "")))

    def test_live_http_failures_and_redirects_are_rejected(self):
        class Handler(BaseHTTPRequestHandler):
            def do_HEAD(self):
                if self.path == "/redirect":
                    self.send_response(302)
                    self.send_header("Location", "/404")
                else:
                    self.send_response(int(self.path.strip("/")))
                self.end_headers()

            do_GET = do_HEAD

            def log_message(self, *args):
                pass

        server = ThreadingHTTPServer(("127.0.0.1", 0), Handler)
        thread = threading.Thread(target=server.serve_forever)
        thread.start()

        def close_server():
            server.shutdown()
            thread.join()
            server.server_close()

        self.addCleanup(close_server)
        base = f"http://127.0.0.1:{server.server_port}"
        for status in ("200", "403", "404", "429", "500", "redirect"):
            with self.subTest(status=status):
                document = self.write_document(
                    "chassis-bom.md", f"[Supplier]({base}/{status})\n",
                )
                result = run_checker(document)
                self.assertEqual(
                    checker_failure(result), status != "200",
                    result.stdout + result.stderr,
                )
                if status != "200":
                    self.assertIn(base, result.stdout + result.stderr)


class BomDocumentationLinkTest(unittest.TestCase):
    def test_every_engineering_markdown_reference_resolves(self):
        self.assertIsNotNone(shutil.which("npx"), "npx is required for BOM link checks")
        documents = sorted(ENGINEERING_DOCS.rglob("*.md"))
        self.assertTrue(documents, f"No Markdown documents found under {ENGINEERING_DOCS}")

        for document in documents:
            with self.subTest(document=document.relative_to(ROOT)):
                result = run_checker(document, root=ROOT)
                self.assertFalse(
                    checker_failure(result),
                    f"{document.relative_to(ROOT)} has a broken reference:\n"
                    f"{result.stdout}{result.stderr}",
                )

    def test_checker_rejects_a_broken_reference(self):
        with tempfile.TemporaryDirectory() as temp:
            document = Path(temp) / "broken.md"
            document.write_text("[Missing](does-not-exist.md)\n", encoding="utf-8")
            result = run_checker(document)
        self.assertTrue(
            checker_failure(result),
            "The link checker did not report a deliberately missing document",
        )


if __name__ == "__main__":
    unittest.main()
