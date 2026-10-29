import { groupComponents } from './visibility.mjs';

export function createVisibilityPanel(container, groups, parts, onChange, onInspect) {
  const inputs = new Map(), groupInputs = new Map(), rows = [];
  let visible = new Set(parts.keys());
  function onlyButton(key, id, label, ids) {
    const button = document.createElement('button');
    button.type = 'button';
    button.textContent = 'Only';
    button.dataset[key] = id;
    button.setAttribute('aria-label', `Show only ${label}`);
    button.addEventListener('click', () => onChange(new Set(ids)));
    return button;
  }
  function toggle(ids, checked) {
    const next = new Set(visible);
    for (const id of ids) {
      if (checked) next.add(id);
      else next.delete(id);
    }
    onChange(next);
  }
  function addGroup(group, parent) {
    const details = document.createElement('details');
    details.open = true;
    const summary = document.createElement('summary');
    const label = document.createElement('label');
    const input = document.createElement('input');
    input.type = 'checkbox';
    input.dataset.group = group.id;
    const ids = groupComponents(group);
    input.addEventListener('click', event => event.stopPropagation());
    input.addEventListener('change', () => toggle(ids, input.checked));
    label.addEventListener('click', event => event.stopPropagation());
    label.append(input, document.createTextNode(` ${group.label}`));
    summary.append(label, onlyButton('onlyGroup', group.id, group.label, ids));
    details.append(summary);
    groupInputs.set(group.id, { input, ids });
    const children = (group.children || []).map(child => addGroup(child, details));
    for (const id of group.components || []) {
      const part = parts.get(id);
      const row = document.createElement('div');
      row.className = 'component-row';
      row.dataset.componentRow = id;
      const box = document.createElement('input');
      box.type = 'checkbox';
      box.dataset.part = id;
      box.setAttribute('aria-label', `Display ${part.label}`);
      box.addEventListener('change', () => toggle([id], box.checked));
      const inspect = document.createElement('button');
      inspect.type = 'button';
      inspect.className = 'inspect-part';
      inspect.textContent = part.label;
      inspect.addEventListener('click', () => onInspect(id));
      row.append(box, inspect, onlyButton('onlyPart', id, part.label, [id]));
      details.append(row);
      inputs.set(id, box);
      rows.push({ row, id, search: `${group.label} ${part.label}`.toLowerCase() });
    }
    parent.append(details);
    return { details, children, ids, label: group.label.toLowerCase() };
  }
  const roots = groups.map(group => addGroup(group, container));
  return {
    update(next, selected) {
      visible = next;
      for (const [id, input] of inputs) {
        input.checked = visible.has(id);
        input.parentElement.classList.toggle('inspected', selected === id);
      }
      for (const { input, ids } of groupInputs.values()) {
        const count = ids.filter(id => visible.has(id)).length;
        input.checked = count === ids.length;
        input.indeterminate = count > 0 && count < ids.length;
      }
    },
    search(value) {
      const query = value.trim().toLowerCase();
      function filter(group, inherited = false) {
        const matches = inherited || (!!query && group.label.includes(query));
        for (const item of rows.filter(item => group.ids.includes(item.id))) {
          item.row.hidden = !matches && !item.search.includes(query);
        }
        for (const child of group.children) filter(child, matches);
        group.details.hidden = !group.ids.some(id => !inputs.get(id).parentElement.hidden);
        if (query && !group.details.hidden) group.details.open = true;
      }
      roots.forEach(group => filter(group));
    },
  };
}
