import { createScene } from './scene.js';
import { createVisibilityPanel } from './visibility-panel.js';
import { readDisplay, writeDisplay, displayedIds } from './visibility.mjs';

const byId = id => document.getElementById(id);
function showError(error) {
  byId('error').hidden = false;
  byId('error').textContent = error.message;
  console.error(error);
}
async function fetchChecked(url) {
  const response = await fetch(url);
  if (!response.ok) throw new Error(`${response.status}: ${await response.text()}`);
  return response;
}

async function start() {
  const config = await (await fetchChecked('/api/config')).json();
  byId('notice').textContent = config.notice;
  byId('source').href = `/files/${config.source}`;
  let scene;
  let currentDocument = '';
  let currentMode = 'presentation';
  let documentRequest = 0;
  let navigationRequest = 0;
  let currentUrl = new URL(location.href);
  const parts = new Map(config.components.map(part => [part.id, part]));
  const ids = [...parts.keys()];
  let display = { visible: new Set(ids), isolated: false };
  for (const part of config.components) {
    byId('component').add(new Option(part.label, part.id));
  }
  const panel = createVisibilityPanel(byId('visibility'), config.groups, parts,
    visible => changeDisplay({ visible, isolated: false }),
    id => { selectPart(id).catch(showError); });

  function applyDisplay() {
    const selected = byId('component').value;
    const shown = displayedIds(ids, display, selected);
    panel.update(display.visible, selected);
    byId('isolate').checked = display.isolated;
    byId('visibility-status').textContent = `${shown.length} of ${ids.length} displayed`
      + (display.isolated && selected ? ' (temporary isolation)' : '');
    byId('fit-visible').disabled = shown.length === 0;
    byId('fit').disabled = !selected || !shown.includes(selected);
    byId('selection').textContent = selected ? parts.get(selected).label
      + (shown.includes(selected) ? '' : ' (hidden; use Isolate selection to inspect)')
      : 'No component inspected';
    scene.display(shown);
  }

  function changeDisplay(next) {
    ++navigationRequest;
    display = next;
    applyDisplay();
    const url = writeDisplay(currentUrl, display, ids);
    currentUrl = url;
    history.pushState(null, '', url.pathname + url.search + url.hash);
  }

  async function showDocument(target, hash = '') {
    const [file, embeddedAnchor] = target.split('#');
    const anchor = hash || (embeddedAnchor ? `#${embeddedAnchor}` : '');
    const request = ++documentRequest;
    if (file !== currentDocument) {
      const html = await (await fetchChecked(`/api/document?path=${encodeURIComponent(file)}`)).text();
      if (request !== documentRequest) return;
      byId('document').innerHTML = html;
      currentDocument = file;
      byId('document-path').textContent = file;
      byId('markdown-source').href = `/files/${file}`;
    }
    const destination = anchor ? document.getElementById(decodeURIComponent(anchor.slice(1))) : null;
    if (anchor && !destination) throw new Error(`Documentation section not found: ${file}${anchor}`);
    byId('document').scrollTop = 0;
    if (destination) {
      const article = byId('document');
      article.scrollTop = destination.getBoundingClientRect().top - article.getBoundingClientRect().top;
    }
    byId('document').dataset.path = file;
    byId('document').dataset.anchor = anchor;
  }

  function setSelection(id, focus) {
    if (id && !parts.has(id)) throw new Error(`Unknown component: ${id}`);
    byId('component').value = id;
    scene.select(id);
    applyDisplay();
    if (focus) scene.fit();
    byId('export').hidden = !id;
    if (id) byId('export').href = `/models/${id}.stl`;
  }

  async function navigate(url, push = true) {
    const request = ++navigationRequest;
    byId('error').hidden = true;
    const requestedMode = url.searchParams.get('mode');
    const requestedDocument = url.searchParams.get('doc') || '';
    currentMode = requestedMode === 'engineering'
      || (!requestedMode && requestedDocument.includes('/technical/'))
      ? 'engineering' : 'presentation';
    byId('mode').value = currentMode;
    const id = url.searchParams.get('component') || '';
    display = readDisplay(url, ids);
    setSelection(id, true);
    currentUrl = new URL(url);
    const target = url.searchParams.get('doc') || (id
      ? parts.get(id)[currentMode === 'presentation' ? 'presentation' : 'document']
      : currentMode === 'presentation' ? config.defaultPresentation : config.defaultDocument);
    await showDocument(target, url.hash);
    if (request !== navigationRequest) return;
    if (push) history.pushState(null, '', url.pathname + url.search + url.hash);
  }

  async function selectPart(id) {
    const url = new URL('/', location.origin);
    if (id) url.searchParams.set('component', id);
    url.searchParams.set('mode', currentMode);
    await navigate(writeDisplay(url, display, ids));
  }

  scene = await createScene(byId('viewport'), config.components,
    id => { selectPart(id).catch(showError); });
  byId('component').addEventListener('change', event => {
    selectPart(event.target.value).catch(showError);
  });
  byId('mode').addEventListener('change', event => {
    const url = new URL(currentUrl);
    url.searchParams.delete('doc');
    url.searchParams.set('mode', event.target.value);
    navigate(url).catch(showError);
  });
  byId('isolate').addEventListener('change', event =>
    changeDisplay({ ...display, isolated: event.target.checked }));
  byId('fit').addEventListener('click', () => scene.fit());
  byId('fit-visible').addEventListener('click', () => scene.fit(true));
  byId('show-all').addEventListener('click', () =>
    changeDisplay({ visible: new Set(ids), isolated: false }));
  byId('hide-all').addEventListener('click', () =>
    changeDisplay({ visible: new Set(), isolated: false }));
  byId('component-search').addEventListener('input', event => panel.search(event.target.value));
  byId('assembly').addEventListener('click', () => {
    display = { visible: new Set(ids), isolated: false };
    byId('component-search').value = '';
    panel.search('');
    selectPart('').catch(showError);
  });
  document.addEventListener('click', event => {
    const link = event.target.closest('a');
    if (!link || event.ctrlKey || event.metaKey || event.shiftKey || event.altKey || event.button) return;
    const url = new URL(link.href);
    if (url.origin !== location.origin) {
      event.preventDefault();
      window.open(url.href, '_blank', 'noopener,noreferrer');
    } else if (url.pathname === '/') {
      event.preventDefault();
      if (!url.searchParams.has('mode')) {
        const target = url.searchParams.get('doc') || '';
        url.searchParams.set('mode',
          target
            ? target.includes('/technical/') ? 'engineering' : 'presentation'
            : currentMode);
      }
      // Reading adjacent sections keeps the current model selection.
      if (url.searchParams.has('doc') && byId('component').value) {
        url.searchParams.set('component', byId('component').value);
      }
      navigate(writeDisplay(url, display, ids)).catch(showError);
    }
  });
  window.addEventListener('popstate', () => navigate(new URL(location.href), false).catch(showError));
  window.addEventListener('pagehide', () => scene.dispose(), { once: true });
  await navigate(new URL(location.href), false);
  byId('viewport').dataset.ready = 'true';
}

start().catch(showError);
