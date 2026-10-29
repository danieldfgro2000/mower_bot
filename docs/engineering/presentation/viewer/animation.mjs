const finite = value => typeof value === 'number' && Number.isFinite(value);

export function validateAnimations(animations, components) {
  if (animations === undefined) return;
  if (!Array.isArray(animations)) throw new Error('Invalid animations: expected a list');
  const known = new Set(components.map(part => part.id));
  const seen = new Set();
  for (const animation of animations) {
    const { id, label, durationMs, components: moved, keyframes } = animation ?? {};
    if (!/^[a-z][a-z0-9-]*$/.test(id ?? '') || !label) throw new Error(`Invalid animation: ${id}`);
    if (seen.has(id)) throw new Error(`Duplicate animation: ${id}`);
    seen.add(id);
    if (!finite(durationMs) || durationMs <= 0) throw new Error(`Invalid animation duration: ${id}`);
    if (!Array.isArray(moved) || !moved.length) throw new Error(`Animation needs components: ${id}`);
    for (const part of moved) {
      if (!known.has(part)) throw new Error(`Unknown animated component: ${part}`);
    }
    if (!Array.isArray(keyframes) || keyframes.length < 2) {
      throw new Error(`Animation needs at least two keyframes: ${id}`);
    }
    keyframes.forEach((frame, i) => {
      if (!Array.isArray(frame.offset) || frame.offset.length !== 3 || !frame.offset.every(finite)) {
        throw new Error(`Invalid keyframe offset: ${id}`);
      }
      if (!finite(frame.at) || (i && frame.at <= keyframes[i - 1].at)) {
        throw new Error(`Keyframe times must be increasing: ${id}`);
      }
    });
    if (keyframes[0].at !== 0 || keyframes[0].offset.some(value => value !== 0)) {
      throw new Error(`Animation must start at 0 in the assembled position: ${id}`);
    }
    if (keyframes.at(-1).at !== 1) throw new Error(`Animation must end at 1: ${id}`);
  }
}

export function poseAt(animation, t) {
  const frames = animation.keyframes;
  const time = Math.min(1, Math.max(0, t));
  const next = frames.findIndex(frame => frame.at >= time);
  if (next <= 0) return [...frames[0].offset];
  const [a, b] = [frames[next - 1], frames[next]];
  const k = (time - a.at) / (b.at - a.at);
  return a.offset.map((value, axis) => value + (b.offset[axis] - value) * k);
}

export function readAnimation(url, animations = []) {
  const id = url.searchParams.get('animation') ?? '';
  const progress = url.searchParams.get('t');
  if (!id) {
    if (progress !== null) throw new Error('Animation progress given without an animation');
    return { id: '', t: 0 };
  }
  if (!animations.some(animation => animation.id === id)) throw new Error(`Unknown animation: ${id}`);
  const t = progress === null ? 0 : Number(progress);
  if (progress === '' || !Number.isFinite(t) || t < 0 || t > 1) {
    throw new Error(`Invalid animation progress: ${progress} (expected 0-1)`);
  }
  return { id, t };
}

export function writeAnimation(url, { id, t }) {
  const result = new URL(url);
  result.searchParams.delete('animation');
  result.searchParams.delete('t');
  if (id) {
    result.searchParams.set('animation', id);
    const rounded = Math.round(t * 1000) / 1000;
    if (rounded > 0) result.searchParams.set('t', String(rounded));
  }
  return result;
}
