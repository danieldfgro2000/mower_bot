import { createScene } from './scene.js';

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
  const visibilityInputs = new Map();
  const parts = new Map(config.components.map(part => [part.id, part]));
  for (const part of config.components) {
    byId('component').add(new Option(part.label, part.id));
    const label = document.createElement('label');
    const input = document.createElement('input');
    input.type = 'checkbox';
    input.checked = true;
    input.addEventListener('change', () => scene.visibility(part.id, input.checked));
    label.append(input, document.createTextNode(` ${part.label}`));
    byId('visibility').append(label);
    visibilityInputs.set(part.id, input);
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
    if (id) visibilityInputs.get(id).checked = true;
    scene.select(id, focus);
    byId('selection').textContent = id ? parts.get(id).label : 'Entire concept assembly';
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
    setSelection(id, true);
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
    await navigate(url);
  }

  scene = await createScene(byId('viewport'), config.components,
    id => { selectPart(id).catch(showError); });
  byId('component').addEventListener('change', event => {
    selectPart(event.target.value).catch(showError);
  });
  byId('mode').addEventListener('change', event => {
    const url = new URL(location.href);
    url.searchParams.delete('doc');
    url.searchParams.set('mode', event.target.value);
    navigate(url).catch(showError);
  });
  byId('isolate').addEventListener('change', event => scene.isolate(event.target.checked));
  byId('fit').addEventListener('click', () => scene.fit());
  byId('assembly').addEventListener('click', () => {
    byId('isolate').checked = false;
    scene.isolate(false);
    for (const [id, input] of visibilityInputs) {
      input.checked = true;
      scene.visibility(id, true);
    }
    selectPart('').catch(showError);
  });
  byId('document').addEventListener('click', event => {
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
      navigate(url).catch(showError);
    }
  });
  window.addEventListener('popstate', () => navigate(new URL(location.href), false).catch(showError));
  window.addEventListener('pagehide', () => scene.dispose(), { once: true });
  await navigate(new URL(location.href), false);
  byId('viewport').dataset.ready = 'true';
}

start().catch(showError);
