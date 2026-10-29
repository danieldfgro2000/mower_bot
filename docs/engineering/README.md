# MowerBot engineering documentation

<a id="document-overview"></a>

Engineering information is separated by audience. The three folders are
connected from each category's index; technical facts remain authoritative,
presentation pages are generated from those facts, and agent documents describe
the maintenance workflow.

| Category | Purpose | Start here |
| --- | --- | --- |
| **Agents** | Repository-specific routing, ownership and maintenance procedures | [Agent guide](agents/README.md) |
| **Presentation** | Concise pitch, key dimensions, prices and sources alongside the 3D viewer | [Engineering pitch](presentation/README.md) |
| **Technical** | Detailed requirements, interfaces, evidence, cost records, CAD and fit studies | [Technical index](technical/README.md) |

## Local 3D viewer

Run from the repository root. First-time setup requires Node.js 20+ and
OpenSCAD on `PATH`:

```sh
npm ci --prefix tool/cad-viewer --ignore-scripts
python3 .github/skills/bom-documentation/scripts/update_costs.py
npm run sync --prefix tool/cad-viewer
npm start --prefix tool/cad-viewer
```

Open `http://127.0.0.1:8765/`. The viewer's **Presentation / Engineering**
selector switches a selected component between its concise pitch card and its
technical section. Use `mode=presentation` or `mode=engineering` in a viewer
URL to choose a mode directly.

Stop the server with Ctrl+C in its terminal. The
[CAD sync procedure](../../.github/skills/cad-documentation-sync/SKILL.md)
describes the checks after changing SCAD, component links or technical anchors.

[↑ Back to documentation index](../index.md)
