import assert from 'node:assert/strict';
import { test } from 'node:test';
import { checkDocumentationLinks } from './links.mjs';

const config = { components: [{ id: 'motor' }, { id: 'battery' }] };
const viewer = '../../../presentation/viewer';

test('every component has a Markdown entry point and every link names a known component', () => {
  const documents = {
    'docs/engineering/technical/modules/02-drive-train/propulsion.md':
      `[![3D motor](${viewer}/previews/motor.png)](${viewer}/index.html?component=motor)`,
    'docs/engineering/technical/modules/04-battery-and-charging/batteries.md':
      `[3D battery](${viewer}/index.html?component=battery)`,
  };
  assert.deepEqual(checkDocumentationLinks(config, documents), []);
});

test('unknown component links, missing entry points and mismatched thumbnails are reported', () => {
  const errors = checkDocumentationLinks(config, {
    'docs/a.md': `[![3D](${viewer}/previews/battery.png)](${viewer}/index.html?component=motor)\n`
      + `[old](${viewer}/index.html?component=removed-part)\n`
      + `![orphan](${viewer}/previews/ghost.png)`,
  });
  assert.ok(errors.some(error => /docs\/a\.md.*unknown component "removed-part"/.test(error)));
  assert.ok(errors.some(error => /docs\/a\.md.*unknown thumbnail "ghost"/.test(error)));
  assert.ok(errors.some(error => /thumbnail "battery" links to component "motor"/.test(error)));
  assert.ok(errors.some(error => /"battery" has no Markdown entry point/.test(error)));
});
