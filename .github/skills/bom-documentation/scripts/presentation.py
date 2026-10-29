"""Generate concise presentation pages from engineering-owned evidence."""

import json
from pathlib import Path
import re


ROOT = Path(__file__).resolve().parents[4]


def heading_id(title):
    return re.sub(r"[^\w -]", "", title.lower()).replace(" ", "-")


def section(markdown, anchor):
    headings = list(re.finditer(r"^(#{1,6})\s+(.+?)\s*#*\s*$", markdown, re.M))
    for index, match in enumerate(headings):
        if heading_id(match.group(2)) != anchor:
            continue
        end = len(markdown)
        for following in headings[index + 1:]:
            if len(following.group(1)) <= len(match.group(1)):
                end = following.start()
                break
        return markdown[match.start():end]
    raise ValueError(f"Missing evidence heading: #{anchor}")


def render(engineering):
    root = engineering.parent.parent
    presentation = engineering / "presentation"
    catalog = json.loads((presentation / "catalog.json").read_text(encoding="utf-8"))
    config = json.loads((presentation / "viewer/components.json").read_text(encoding="utf-8"))
    ids = {component["id"] for component in config["components"]}
    entries = {item["id"]: item for item in catalog["components"]}
    if len(entries) != len(catalog["components"]) or not set(entries) <= ids:
        raise ValueError("Presentation catalog contains duplicate or unknown component IDs")
    if config.get("defaultPresentation") != "docs/engineering/presentation/README.md":
        raise ValueError("Viewer default presentation must target the generated pitch page")
    for component in config["components"]:
        expected = f"docs/engineering/presentation/parts.md#{component['id']}"
        if component.get("presentation") != expected:
            raise ValueError(f"Invalid presentation target for component {component['id']}")

    cards = []
    pitch_rows = []
    for component in config["components"]:
        item = entries.get(component["id"], {})
        target = component["document"]
        details = []
        evidence_sections = []
        for evidence in item.get("evidence", []):
            source = evidence["target"]
            if not source.startswith("docs/engineering/technical/") or "#" not in source:
                raise ValueError(f"Presentation evidence must link to technical documentation: {source}")
            file, anchor = source.split("#", 1)
            markdown = (root / file).read_text(encoding="utf-8")
            excerpt = section(markdown, anchor)
            for quote in evidence["quotes"]:
                if quote not in excerpt:
                    raise ValueError(f"Stale presentation evidence in {source}: {quote}")
            evidence_sections.append((source, excerpt))
        for source in item.get("sources", []):
            if not any(source["url"] in excerpt for _, excerpt in evidence_sections):
                raise ValueError(f"Supplier source is not present in its evidence section: {source['url']}")
        for fact in item.get("facts", []):
            if not any(fact["evidence"] in excerpt for _, excerpt in evidence_sections):
                raise ValueError(f"Stale presentation fact: {component['id']} / {fact['label']}")
            details.append(f"| {fact['label']} | {fact['value']} |")
        table = ""
        if details:
            table = "| | |\n| --- | --- |\n" + "\n".join(details) + "\n\n"
        image = (
            f"[![{component['label']}](viewer/previews/{component['id']}.png)]"
            f"(viewer/index.html?component={component['id']}&mode=presentation)\n\n"
        )
        status = item.get("status", "See technical scope; this is a study element.")
        technical_link = f"../{target.removeprefix('docs/engineering/')}"
        source_links = " · ".join(
            f"[{source['label']}]({source['url']})" for source in item.get("sources", [])
        )
        evidence_links = ""
        if item.get("evidence"):
            evidence_links = " · ".join(
                f"[Technical evidence](../{source.split('#')[0].removeprefix('docs/engineering/')}"
                f"#{source.split('#', 1)[1]})"
                for source in dict.fromkeys(entry["target"] for entry in item["evidence"])
            )
        links = " · ".join(part for part in [source_links, evidence_links] if part)
        cards.extend([
            f'<a id="{component["id"]}"></a>',
            "",
            f"### {component['label']}",
            "",
            f"**Status:** {status}",
            "",
            image.rstrip(),
            table.rstrip(),
            "",
            f"**Read more:** [{component['label']} technical detail]({technical_link})"
            + (f" · {links}" if links else ""),
            "",
        ])
        pitch_rows.append(
            f"| [{component['label']}](parts.md#{component['id']}) | {status} |"
        )

    parts_text = (
        "# Presentation parts\n\n"
        "**Concise, generated component cards.** For assumptions, requirements,\n"
        "interfaces and release holds, follow the linked technical detail.\n\n"
        + "\n".join(cards)
        + "\n[↑ Back to presentation](README.md#engineering-pitch)\n"
    )
    pitch_text = (
        "# MowerBot engineering pitch\n\n"
        "<a id=\"document-overview\"></a>\n\n"
        "**Status:** unqualified engineering study. Dimensions and listed prices\n"
        "are sourcing references, not a released configuration or delivered quote.\n\n"
        "## Engineering pitch\n\n"
        "A supervised, low-speed tracked platform built around two self-contained\n"
        "pods and a width-adjustable frame. The first implementation direction is\n"
        "a battery-electric chassis carrying the DAC 9100 mower; autonomy and\n"
        "production readiness are not claimed.\n\n"
        "**Explore:** [Interactive 3D viewer](viewer/index.html?mode=presentation) · "
        "[All component cards](parts.md) · "
        "[Technical design and evidence](../technical/modules/README.md) · "
        "[Engineering agent guide](../agents/README.md)\n\n"
        "## Component shortlist\n\n"
        "| Component | Current presentation status |\n"
        "| --- | --- |\n"
        + "\n".join(pitch_rows)
        + "\n\nComponent cards show only decision-relevant dimensions, public price "
        "references and direct sources. Their technical links retain detailed "
        "assumptions, compatibility questions and holds.\n"
    )
    return {
        presentation / "README.md": pitch_text,
        presentation / "parts.md": parts_text,
    }


if __name__ == "__main__":
    for path, content in render(ROOT / "docs/engineering").items():
        path.write_text(content, encoding="utf-8")
