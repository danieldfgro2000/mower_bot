import assert from 'node:assert/strict';
import { test } from 'node:test';
import { resolveDocumentLink, renderDocument, resolveServedFile } from './core.mjs';

const motorDoc = 'docs/engineering/technical/modules/02-drive-train/propulsion.md';

test('Markdown links retain their owning scope and section in the local reader', () => {
  assert.equal(
    resolveDocumentLink('propulsion.md#motor-to-track-mounting', motorDoc),
    '/?doc=docs%2Fengineering%2Ftechnical%2Fmodules%2F02-drive-train%2Fpropulsion.md#motor-to-track-mounting',
  );
  assert.equal(
    resolveDocumentLink('../../../presentation/viewer/index.html?component=motor', motorDoc),
    '/?component=motor',
  );
  assert.equal(
    resolveDocumentLink(
      '../../../presentation/viewer/index.html?component=track&mode=presentation', motorDoc,
    ),
    '/?component=track&mode=presentation',
  );
  assert.equal(resolveDocumentLink('https://example.com/data.pdf', motorDoc),
    'https://example.com/data.pdf');
});

test('rendered Markdown keeps GitHub heading IDs, explicit anchors and 3D images', () => {
  const html = renderDocument('# Motor\n\n<a id="legacy-motor"></a>\n\n'
    + '[Mount](propulsion.md#motor-to-track-mounting)\n\n'
    + '[![3D motor](../../../presentation/viewer/previews/motor.png)]'
    + '(../../../presentation/viewer/index.html?component=motor)\n\n<script>alert(1)</script>', motorDoc);
  assert.match(html, /id="motor"/);
  assert.match(html, /id="legacy-motor"/);
  assert.match(html, /href="\/\?component=motor"/);
  assert.match(html, /src="\/files\/docs\/engineering\/presentation\/viewer\/previews\/motor.png"/);
  assert.doesNotMatch(html, /<script>/);
});

test('local file serving excludes credentials, traversal and arbitrary dependencies', () => {
  assert.equal(resolveServedFile('/files/docs/engineering/technical/cad/module-01-track-pod-fit.scad'),
    'docs/engineering/technical/cad/module-01-track-pod-fit.scad');
  assert.equal(resolveServedFile('/files/plan.md'), 'plan.md');
  assert.equal(resolveServedFile('/files/arduino/MowerESP32/secrets.h'), null);
  assert.equal(resolveServedFile('/files/docs/../../.git/config'), null);
  assert.equal(resolveServedFile('/files/docs/%2e%2e/%2e%2e/.git/config'), null);
  assert.equal(resolveServedFile('/files/docs/%00bad.md'), null);
  assert.equal(resolveServedFile('/vendor/../../../.git/config'), null);
  assert.equal(resolveDocumentLink('javascript:alert(1)', motorDoc), null);
  assert.equal(resolveDocumentLink('../../../../.git/config', motorDoc), null);
});
