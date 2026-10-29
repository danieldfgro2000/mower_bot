export function groupComponents(group) {
  return group.components || group.children.flatMap(groupComponents);
}

export function validateGroups(groups, components) {
  if (!Array.isArray(groups) || !groups.length) throw new Error('Missing component groups');
  const known = new Set(components.map(part => part.id));
  const assigned = new Set(), groupIds = new Set();
  function visit(group) {
    if (!group || !/^[a-z][a-z0-9-]*$/.test(group.id) || !group.label
        || groupIds.has(group.id)) throw new Error('Invalid or duplicate component group');
    groupIds.add(group.id);
    if (Array.isArray(group.components) && group.components.length && !group.children) {
      for (const id of group.components) {
        if (!known.has(id) || assigned.has(id)) throw new Error(`Unknown or repeated grouped component: ${id}`);
        assigned.add(id);
      }
    } else if (Array.isArray(group.children) && group.children.length && !group.components) {
      group.children.forEach(visit);
    } else throw new Error(`Group needs components or children: ${group.id}`);
  }
  groups.forEach(visit);
  if (assigned.size !== known.size) throw new Error('Every component must belong to exactly one group');
}

export function readDisplay(url, ids) {
  const value = url.searchParams.get('visible');
  const visible = new Set(value === null ? ids : value === '' ? [] : value.split(','));
  for (const id of visible) {
    if (!ids.includes(id)) throw new Error(`Unknown visible component: ${id || '(empty)'}`);
  }
  if (url.searchParams.has('isolate') && url.searchParams.get('isolate') !== '1') {
    throw new Error('Invalid isolate setting: expected 1');
  }
  return { visible, isolated: url.searchParams.has('isolate') };
}

export function writeDisplay(url, { visible, isolated }, ids) {
  const result = new URL(url);
  if (ids.every(id => visible.has(id))) result.searchParams.delete('visible');
  else result.searchParams.set('visible', ids.filter(id => visible.has(id)).join(','));
  if (isolated) result.searchParams.set('isolate', '1');
  else result.searchParams.delete('isolate');
  return result;
}

export function displayedIds(ids, { visible, isolated }, selected) {
  return isolated && selected ? [selected] : ids.filter(id => visible.has(id));
}
