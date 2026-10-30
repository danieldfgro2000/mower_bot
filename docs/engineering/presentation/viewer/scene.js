import * as THREE from 'three';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
import { STLLoader } from 'three/addons/loaders/STLLoader.js';

export async function createScene(container, components, onSelect) {
  const renderer = new THREE.WebGLRenderer({ antialias: true });
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
  container.append(renderer.domElement);
  const scene = new THREE.Scene();
  scene.background = new THREE.Color('#e9eef4');
  const camera = new THREE.PerspectiveCamera(42, 1, 1, 15000);
  const controls = new OrbitControls(camera, renderer.domElement);
  controls.enableDamping = false;
  scene.add(new THREE.HemisphereLight(0xffffff, 0x586776, 3));
  const light = new THREE.DirectionalLight(0xffffff, 3);
  light.position.set(-500, 1000, 1400);
  scene.add(light);
  const meshes = new Map();
  const loader = new STLLoader();
  await Promise.all(components.map(async component => {
    const group = new THREE.Group();
    group.userData.preserveColors = !!component.renderParts;
    await Promise.all((component.renderParts ?? [component]).map(async part => {
      const geometry = await loader.loadAsync(`/models/${part.id}.stl`);
      geometry.computeVertexNormals();
      const mesh = new THREE.Mesh(geometry, new THREE.MeshStandardMaterial({
        color: part.color, roughness: .65, metalness: .15,
        transparent: true, opacity: .7, side: THREE.DoubleSide,
      }));
      mesh.userData.id = component.id;
      group.add(mesh);
    }));
    scene.add(group);
    meshes.set(component.id, group);
  }));
  let selected = '';
  let displayed = new Set(components.map(part => part.id));
  const render = () => {
    renderer.domElement.dataset.camera = [camera.position.x, camera.position.y, camera.position.z,
      camera.aspect].every(Number.isFinite) && camera.aspect > 0 ? 'finite' : 'invalid';
    renderer.render(scene, camera);
  };
  function update() {
    for (const [id, group] of meshes) {
      group.visible = displayed.has(id);
      group.traverse(mesh => {
        if (!mesh.isMesh) return;
        mesh.material.opacity = selected ? (id === selected ? 1 : .16) : .7;
        mesh.material.depthWrite = !selected || id === selected;
        mesh.material.emissive.set(id === selected && !group.userData.preserveColors
          ? '#21374b' : '#000000');
      });
    }
    renderer.domElement.dataset.selected = selected;
    renderer.domElement.dataset.visible = JSON.stringify([...meshes.keys()].filter(id => meshes.get(id).visible));
    render();
  }
  let pendingFit = null;
  const hasArea = () => container.clientWidth > 0 && container.clientHeight > 0;
  function applyPose(offsets) {
    for (const [id, mesh] of meshes) mesh.position.fromArray(offsets[id] ?? [0, 0, 0]);
  }
  let currentPose = {};
  function fit(allVisible = false, poses = []) {
    // A collapsed pane has no aspect ratio; fit once it is shown again.
    if (!hasArea()) {
      pendingFit = [allVisible, poses];
      return;
    }
    pendingFit = null;
    const box = new THREE.Box3();
    // Frame every requested pose so animated parts stay in view.
    for (const pose of [currentPose, ...poses]) {
      applyPose(pose);
      for (const [id, mesh] of meshes) {
        if (mesh.visible && (allVisible || !selected || id === selected)) box.expandByObject(mesh);
      }
    }
    applyPose(currentPose);
    if (box.isEmpty()) return;
    const center = box.getCenter(new THREE.Vector3());
    const size = box.getSize(new THREE.Vector3()).length();
    const distance = size / (2 * Math.tan(THREE.MathUtils.degToRad(camera.fov / 2)))
      / Math.min(camera.aspect, 1) * 1.15;
    camera.position.copy(center).add(new THREE.Vector3(-.8, .65, 1.2).normalize().multiplyScalar(distance));
    camera.near = Math.max(.1, distance / 1000);
    camera.far = Math.max(15000, distance * 10);
    camera.updateProjectionMatrix();
    controls.target.copy(center);
    controls.update();
    render();
  }
  const observer = new ResizeObserver(() => {
    if (!hasArea()) return;
    const { width, height } = container.getBoundingClientRect();
    camera.aspect = width / height;
    camera.updateProjectionMatrix();
    renderer.setSize(width, height, false);
    if (pendingFit !== null) fit(...pendingFit);
    else render();
  });
  observer.observe(container);
  controls.addEventListener('change', render);
  let down;
  renderer.domElement.addEventListener('pointerdown', event => { down = [event.clientX, event.clientY]; });
  renderer.domElement.addEventListener('pointerup', event => {
    if (event.button !== 0 || !down || Math.hypot(event.clientX - down[0], event.clientY - down[1]) > 5) return;
    const rect = renderer.domElement.getBoundingClientRect();
    const pointer = new THREE.Vector2(
      (event.clientX - rect.left) / rect.width * 2 - 1,
      -(event.clientY - rect.top) / rect.height * 2 + 1,
    );
    const raycaster = new THREE.Raycaster();
    raycaster.setFromCamera(pointer, camera);
    const hit = raycaster.intersectObjects([...meshes.values()].filter(mesh => mesh.visible))[0];
    if (hit) onSelect(hit.object.userData.id);
  });
  fit();
  renderer.domElement.dataset.pose = '{}';
  renderer.domElement.dataset.progress = '0';
  return {
    select(id) {
      selected = id;
      update();
    },
    display(ids) { displayed = new Set(ids); update(); },
    pose(offsets, progress) {
      currentPose = Object.fromEntries(Object.entries(offsets)
        .filter(([, offset]) => offset.some(value => value !== 0)));
      applyPose(currentPose);
      renderer.domElement.dataset.pose = JSON.stringify(currentPose);
      renderer.domElement.dataset.progress = String(progress);
      render();
    },
    fit,
    dispose() {
      observer.disconnect();
      controls.dispose();
      for (const group of meshes.values()) {
        group.traverse(mesh => {
          if (!mesh.isMesh) return;
          mesh.geometry.dispose();
          mesh.material.dispose();
        });
      }
      renderer.dispose();
    },
  };
}
