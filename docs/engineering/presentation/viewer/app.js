import { createScene } from './scene.js';
import { createVisibilityPanel } from './visibility-panel.js';
import { readDisplay, writeDisplay, displayedIds } from './visibility.mjs';
import { poseAt, readAnimation, writeAnimation } from './animation.mjs';

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
  let currentLayout = 'split';
  let documentRequest = 0;
  let navigationRequest = 0;
  let currentUrl = new URL(location.href);
  const parts = new Map(config.components.map(part => [part.id, part]));
  const ids = [...parts.keys()];
  let display = { visible: new Set(ids), isolated: false };
  const animations = new Map((config.animations ?? []).map(item => [item.id, item]));
  let animationState = { id: '', t: 0 };
  let playing = 0;
  for (const part of config.components) {
    byId('component').add(new Option(part.label, part.id));
  }
  for (const animation of animations.values()) {
    byId('animation').add(new Option(animation.label, animation.id));
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
    updateAnimationStatus(shown);
  }

  function animationPose(state = animationState) {
    const animation = animations.get(state.id);
    if (!animation) return {};
    const offset = poseAt(animation, state.t);
    return Object.fromEntries(animation.components.map(id => [id, offset]));
  }
  function updateAnimationStatus(shown) {
    const animation = animations.get(animationState.id);
    const hidden = animation?.components.every(id => !shown.includes(id));
    byId('animation-status').textContent = hidden
      ? `Animated parts are hidden; display ${animation.components.map(id => parts.get(id).label)
        .join(' or ')} to watch the motion.` : '';
  }
  function applyAnimation() {
    const animation = animations.get(animationState.id);
    scene.pose(animationPose(), animationState.t);
    byId('animation').value = animationState.id;
    byId('animation-progress').value = String(Math.round(animationState.t * 1000));
    byId('animation-value').textContent = `${Math.round(animationState.t * 100)}%`;
    byId('animation-progress').disabled = !animation;
    byId('animation-play').disabled = !animation;
    byId('animation-play').textContent = playing ? 'Pause' : animationState.t >= 1 ? 'Replay' : 'Play';
    updateAnimationStatus(displayedIds(ids, display, byId('component').value));
  }
  function stopPlayback() {
    cancelAnimationFrame(playing);
    playing = 0;
  }
  // Progress is view state: replace the entry so playback does not flood history.
  function saveProgress() {
    currentUrl = writeAnimation(currentUrl, animationState);
    history.replaceState(null, '', currentUrl.pathname + currentUrl.search + currentUrl.hash);
  }
  function togglePlayback() {
    const animation = animations.get(animationState.id);
    if (!animation) return;
    if (playing) {
      stopPlayback();
      applyAnimation();
      saveProgress();
      return;
    }
    if (animationState.t >= 1) animationState = { ...animationState, t: 0 };
    let last = performance.now();
    const step = now => {
      const t = Math.min(1, animationState.t + Math.max(0, now - last) / animation.durationMs);
      last = now;
      animationState = { ...animationState, t };
      if (t >= 1) {
        playing = 0;
        saveProgress();
      } else playing = requestAnimationFrame(step);
      applyAnimation();
    };
    playing = requestAnimationFrame(step);
    applyAnimation();
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

  function readLayout(url) {
    const layout = url.searchParams.get('layout') ?? 'split';
    if (!['split', 'cad', 'docs'].includes(layout)) throw new Error(`Invalid layout: ${layout}`);
    return layout;
  }
  function writeLayout(url, layout) {
    const next = new URL(url);
    if (layout === 'split') next.searchParams.delete('layout');
    else next.searchParams.set('layout', layout);
    return next;
  }
  function applyLayout(layout) {
    currentLayout = layout;
    document.querySelector('main').dataset.layout = layout;
    for (const button of document.querySelectorAll('.layout-switch button')) {
      button.setAttribute('aria-pressed', String(button.dataset.layout === layout));
    }
  }

  async function navigate(url, push = true) {
    const request = ++navigationRequest;
    byId('error').hidden = true;
    applyLayout(readLayout(url));
    const requestedMode = url.searchParams.get('mode');
    const requestedDocument = url.searchParams.get('doc') || '';
    currentMode = requestedMode === 'engineering'
      || (!requestedMode && requestedDocument.includes('/technical/'))
      ? 'engineering' : 'presentation';
    byId('mode').value = currentMode;
    const id = url.searchParams.get('component') || '';
    display = readDisplay(url, ids);
    stopPlayback();
    animationState = readAnimation(url, config.animations);
    applyAnimation();
    setSelection(id, true);
    currentUrl = new URL(url);
    const animationDocument = animations.get(animationState.id)?.document;
    const target = url.searchParams.get('doc') || (id
      ? parts.get(id)[currentMode === 'presentation' ? 'presentation' : 'document']
      : animationDocument || (currentMode === 'presentation'
        ? config.defaultPresentation : config.defaultDocument));
    await showDocument(target, url.hash);
    if (request !== navigationRequest) return;
    if (push) history.pushState(null, '', url.pathname + url.search + url.hash);
  }

  async function selectPart(id) {
    const url = new URL('/', location.origin);
    if (id) url.searchParams.set('component', id);
    url.searchParams.set('mode', currentMode);
    await navigate(writeAnimation(writeLayout(writeDisplay(url, display, ids), currentLayout),
      animationState));
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
    stopPlayback();
    animationState = { id: '', t: 0 };
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
      // A 3D thumbnail or animation link asks to see the model, so documentation focus opens split view.
      const opensModel = (url.searchParams.has('component') || url.searchParams.has('animation'))
        && !url.searchParams.has('doc');
      const layout = url.searchParams.has('layout') ? url.searchParams.get('layout')
        : opensModel && currentLayout === 'docs' ? 'split' : currentLayout;
      const next = writeLayout(writeDisplay(url, display, ids), layout);
      navigate(url.searchParams.has('animation') ? next : writeAnimation(next, animationState))
        .catch(showError);
    }
  });
  byId('animation').addEventListener('change', event => {
    stopPlayback();
    ++navigationRequest;
    animationState = { id: event.target.value, t: 0 };
    applyAnimation();
    const animation = animations.get(animationState.id);
    if (animation) scene.fit(true, [animationPose({ id: animation.id, t: 1 })]);
    currentUrl = writeAnimation(currentUrl, animationState);
    history.pushState(null, '', currentUrl.pathname + currentUrl.search + currentUrl.hash);
  });
  byId('animation-play').addEventListener('click', togglePlayback);
  byId('animation-progress').addEventListener('input', event => {
    stopPlayback();
    animationState = { ...animationState, t: Number(event.target.value) / 1000 };
    applyAnimation();
  });
  byId('animation-progress').addEventListener('change', saveProgress);
  for (const button of document.querySelectorAll('.layout-switch button')) {
    button.addEventListener('click', () => {
      if (button.dataset.layout === currentLayout) return;
      ++navigationRequest;
      applyLayout(button.dataset.layout);
      currentUrl = writeLayout(currentUrl, currentLayout);
      history.pushState(null, '', currentUrl.pathname + currentUrl.search + currentUrl.hash);
    });
  }
  window.addEventListener('popstate', () => navigate(new URL(location.href), false).catch(showError));
  window.addEventListener('pagehide', () => scene.dispose(), { once: true });
  await navigate(new URL(location.href), false);
  byId('viewport').dataset.ready = 'true';
}

start().catch(showError);
