# Evidence — 2026-09-27 11:06 UTC

## 13:36 UTC continuation: FPS navigation and backend limitation

- test_fps_navigation.gd uses GUI-focused Enter to enter FPS from SkeletonIK,
  then Escape and focused Enter to return. Both scene transitions pass. Free
  cursor events leave player yaw unchanged, as expected.
- fps-navigation-20260927.log:4/8 pass, exit1. Captured mode, yaw response and
  both pitch clamps fail because Input.mouse_mode stays VISIBLE. Do not count
  those features as verified or patch gameplay to bypass the captured-mode gate.
- Isolated test_mouse_backend.gd establishes the environment limitation without
  loading any scene: mouse-backend-20260927.log reports backend headless and
  requested modes VISIBLE0/CAPTURED2/HIDDEN1 all read back0. Restored original
  mode. Thus captured mouse-look requires a supported display for verification;
  known user-closed capture constraint forbids reopening visible windows now.
- Failed evidence retained. No production change this turn. Editor-only visual
  paths and model-specific provenance remain pending along with both films.
  Next feasible item may proceed under this recorded external capture blocker;
  retain all unfinished checks here for a display-enabled revisit.

## 13:06 UTC continuation: FABRIK mode correction

- Constructed test_modes.gd checks scheduling flags for all four modes on both
  solver scripts. modes-before-20260927.log reproduces one failure of8: FABRIK
  physics mode enabled ordinary process instead. Local copy fixed with one-line
  set_physics_process(true). modes-after-20260927.log passes8/8 clean, exit0.
  This is a setter fixture, not editor interaction or gameplay footage.
- navigation-modes-regression-20260927.log passes12/12, exit0 clean. Default
  scene scheduling and mouse-driven arm response still pass. Original source
  untouched; failed evidence retained.
- DAE asset headers for robot and pistol identify author Anonymous and a Blender
  Collada exporter by Juan Linietsky. Exporter authorship is NOT model authorship.
  No independent model license established by those headers; retain root license
  and source notes, keep asset-specific provenance review pending.
- Remaining FPS cursor/look/scene transition, editor-only material paths and
  visual/film checks are pending. Existing capture blocker unchanged.

## 12:36 UTC continuation: FPS input

- Read full580-line FPS scene and bullet scene, and reread both FPS scripts.
- Added test_fps.gd using actual scene and normal keyboard/mouse events; no
  positioning, forced animation or direct gameplay callbacks. Headless only.
- fps-input-20260927.log: 11/11 assertions, exit0 clean. Floor contact, W movement,
  Shift sprint, Q lean/recenter, Space jump, right-click aim/un-aim with completed
  FOV60/80 animation, one left-click bullet, moving velocity, natural5-second
  despawn all pass. No damage/impact, visual weapon alignment or heard audio claim.
- All four main scenes now source-read. FPS scene-switching and mouse-look clamps,
  editor-only update-mode paths, and DAE asset-specific attribution still pending.
  Existing capture blocker persists; no recording windows or films launched.

## 12:06 UTC continuation: sampling failure resolved

- The previous two SkeletonIK failures were a test observation-timing problem:
  polling poses after a SceneTree timer did not capture completed modifier output.
  Added a read-only skeleton_updated signal observer to snapshot upper-arm poses.
  No solver/target/gameplay mutation or production code fix was needed.
- navigation-evaluated-20260927.log and navigation-final-20260927.log each pass
  all12 assertions cleanly, exit0. Both scenes emit skeleton_updated samples;
  their evaluated finite upper-arm poses change with actual mouse events.
  Four actual GUI transitions still pass. Final harness defaults to evaluated
  snapshots and clears the cache per scene; --raw reproduces the earlier sampling.
- This establishes evaluated pose response, not final-frame appearance or IK
  accuracy against an anatomical target. Original failure logs remain intact.
  FPS/editor/asset checks and both films remain pending; capture constraint
  unchanged. Continue item63 rather than claiming completion.

## 11:36 UTC continuation

- Read FABRIK and SkeletonIK scenes fully. Added test_navigation.gd: actual
  GUI buttons focused by harness then Enter press/release, actual mouse events.
  No direct solver calls or changed scene targets/bone poses.
- navigation-20260927.log: 12 assertions, 10 pass and 2 fail, exit1. All four
  transitions LookAt -> FABRIK -> SkeletonIK -> FABRIK -> LookAt pass. FABRIK
  left/right upper-arm poses remain finite and change after mouse input.
- Both built-in SkeletonIK upper-arm response assertions fail headlessly.
  navigation-diagnostic-20260927.log repeats 10/12, exit1: targets do change
  from (-4.274547,-1.177049,-6.659039) to (4.137471,2.174437,-6.492546), and both
  solvers report is_running true. Poses remain finite but unchanged at sample.
  This is unresolved, not a clean behavior pass or confirmed engine defect.
  Investigate modifier evaluation/headless limitations before changing code;
  no visible window may be reopened under the existing capture constraint.
- Original failed logs preserved. No production changes this turn. A subsequent
  cat probe used the wrong working-directory-relative path and failed; no write.
- FPS, editor-only paths and asset-specific attribution still pending. No films
  produced or approvals claimed. Continue item63 diagnostics next.

- Source README, model README, project.godot and all eight GDScript files read.
  Full LookAt scene read. Other scenes and DAE asset metadata still pending.
  No source AGENTS.md found. Copied to a new sibling, not the public framework.
- import-20260927.log: exit 0 clean. runtime-20260927.log: ordinary headless
  main scene startup, quit-after120, exit 0 clean. No visible window.
- look-input-20260927.log: seven actual-scene mouse-input assertions pass,
  exit 0 clean. Root viewport set to1152x648. No direct solver calls or forced
  target/bone mutations. Bone poses are state evidence, not inspected frames.
- FABRIK update_mode1 setter appears to enable process instead of physics_process;
  this is an untested source observation, not a reproduced/fixed issue. Editor
  material flags and transform math also require bounded testing before claims.
- No worker/render active before starting. Known factory stoppage and capture
  constraint unchanged. Both films/human approval pending; continue this item.
- Original files/assets/licenses preserved, no uploads or package installation.
