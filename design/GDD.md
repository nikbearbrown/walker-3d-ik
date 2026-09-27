# walker-3d-ik — Game Design Document (recovered)

| | |
|---|---|
| Version | 0.1.0-recovered |
| Date | 2026-09-27 |
| Author | Zelda (agent, silent), for Nik Bear Brown |
| Mode | recovered — `/gdd reverse --path godot silent` |
| Revision | 1 |
| Gates | vision ○ · systems ○ · world ○ · scope ○ — gate — unsigned at time of writing |
| Project kind | **tech demo** (four linked IK scenes; the last is a game-shaped FPS sandbox, still not a game) |

Provenance tags: `[OBSERVED path:line]` the code or scene does this · `[INFERRED]` the code strongly implies this, evidence stated · `[MISSING]` the code cannot tell you this; logged in `decisions.md`. Paths are relative to `godot/` unless they name a folder-root file. This document describes what exists. It approves none of it.

**Evidence image:** `godot/screenshots/cube.png` — upstream screenshot: lookat / fabrik scene; embedded in `design/DECK.html`.
*`[OBSERVED godot/screenshots/cube.png]` — shipped with the upstream Godot demo.*

**Evidence image:** `godot/screenshots/fps_gun.png` — upstream screenshot: fps example; embedded in `design/DECK.html`.
*`[OBSERVED godot/screenshots/fps_gun.png]` — shipped with the upstream demo. Neither is a Walker capture; "No footage or completed films yet" (`README.md`).*

## 1. Vision summary

**What it is.** Four scenes linked by Next / Previous buttons, each driving the same robot rig (the Godot Battle Bot) with inverse kinematics: (1) LookAt — head and upper arms turn toward mouse-driven targets; (2) FABRIK — script-based arm chains reach for targets; (3) SkeletonIK3D — the engine's built-in solver does the same; (4) an FPS example where FABRIK and LookAt pose the robot's arms and chest around a pistol while you walk, jump, lean, aim and fire. `[OBSERVED look_at_ik.tscn; fabrik_ik.tscn; skeleton_ik.tscn; fps/fps_example.tscn]`

**Upstream purpose.** "An example of different Inverse Kinematic algorithms implemented in Godot. It contains four scenes, showing different ways they can be used." `[OBSERVED godot/README.md:3-5]`

**Why it is in Walker.** Independent local copy of `3d/ik` at commit a3b5c113 with one production fix (FABRIK physics scheduling); both Liam films pending. `[OBSERVED README.md]` Film purpose and audience `[MISSING]` (Q-01).

**Player fantasy / logline.** None for scenes 1-3. Scene 4 has player verbs — move, sprint, jump, lean, aim, fire — `[OBSERVED fps/example_player.gd:70-164]` but no targets, damage, enemies, objective or score; bullets fly and despawn after 5 s. `[OBSERVED fps/simple_bullet.gd]` It is an animation showcase wearing an FPS costume: its own label calls it "Example use case: Dynamic FPS Animations." `[OBSERVED fps/fps_example.tscn:409]` Adding a goal would be design, not recovery.

**Biggest unresolved question.** Is the film about *IK as a technique* (three solvers compared on one rig) or about *IK as game feel* (procedural arms in first person)? The four scenes support both; the film cannot do both well. Q-01.

## 2. Design pillars

None stated. `[MISSING]` (Q-02). Implied `[INFERRED]`:
1. **Same rig, different solver.** Scenes 1-3 reuse the robot and the mouse-driven `Targets` node; only the solver changes. Evidence: `target_from_mousepos.gd` on each scene's Camera3D (`look_at_ik.tscn:31`, `fabrik_ik.tscn:38`, `skeleton_ik.tscn:32`).
2. **Show the use case last.** The sequence ends in a playable context rather than a lab. Evidence: button chain → `fps/fps_example.tscn` (`skeleton_ik.tscn:127`).
3. **Honest about rough edges.** The FABRIK scene tells the user they will see save errors and asks for a fix (`fabrik_ik.tscn:129-131`); the FABRIK label recommends 3+ bones while using 2 on the left (`:153-155`).

## 3. Core loop

Scenes 1-3, recovered **viewing loop** (`diagrams/scene-flow.svg`):
1. Move the mouse; `Targets` follows the projected cursor ray (12 units, axis flipped). `[OBSERVED target_from_mousepos.gd:9-19; look_at_ik.tscn:33]`
2. Solvers pose head / arms each process frame. `[OBSERVED addons/sade/ik_look_at.gd, ik_fabrik.gd; skeleton_ik_runner.gd:3-4]`
3. Next / Previous scene. `[OBSERVED button_change_scene.gd]`

Scene 4, recovered **sandbox loop** (`diagrams/fps-sandbox.svg`):
1. Mouse look (captured), move / sprint / jump / lean. `[OBSERVED fps/example_player.gd:70-164, 205-217]`
2. Right-click toggles aim (FOV 80 ↔ 60 via AnimationPlayer). `[OBSERVED example_player.gd:93-105; fps-input-20260927.log]`
3. Left-click fires a bullet every 0.15 s at speed 100; each despawns after 5 s. `[OBSERVED example_player.gd:15-16, 109-119; simple_bullet.gd:3-15]`
4. IK keeps the robot's chest, hands and head pointed along the aim. `[OBSERVED fps_example.tscn:470-555]`
5. No end state; Escape frees the mouse; Previous returns to SkeletonIK. `[OBSERVED]`

## 4. Player Experience Goals

None stated. `[MISSING]` (Q-01). Candidates, unconfirmed:
- PX-01? `[INFERRED from pillar 1]` The viewer can tell FABRIK from SkeletonIK3D by watching the same arm reach.
- PX-02? `[INFERRED from fps_example.tscn:409]` In first person, leaning and aiming feel "physical" because the arms re-solve instead of playing canned animation.
Neither has been observed by a human. Human playtests: 0.

## 5. Mechanics

### M-01 Mouse-driven targets `[OBSERVED target_from_mousepos.gd]`
`MOVEMENT_SPEED = 12` (exported), `flip_axis` true in all three scenes. Verified: mouse motion moves targets. `[OBSERVED look-input-20260927.log]`

### M-02 LookAt IK `[OBSERVED addons/sade/ik_look_at.gd]`
`@tool` Node3D; exports `skeleton_path`, `bone_name`, `update_mode` (process / physics / notification / none), `look_at_axis`, `interpolation`, per-axis rotation overrides, `additional_rotation`, additional-bone positioning, `debug_messages` (lines 4-50). Used for Head, upper arms (scene 1), hands (scene 2) and Chest / Head / hands (scene 4). Head and both upper arms verified to rotate with mouse input. `[OBSERVED look-input-20260927.log]`

### M-03 FABRIK IK `[OBSERVED addons/sade/ik_fabrik.gd]`
`@tool` Node3D; exports `skeleton_path`, `bones_in_chain`, `bones_in_chain_lengths`, `update_mode`, `chain_iterations`, `limit_chain_iterations`, `reset_iterations_on_update`, `use_middle_joint_target` (lines 11-97). **Walker production edit:** physics mode now calls `set_physics_process(true)` (line 68); before the fix it enabled ordinary process. `[OBSERVED README.md; modes-before/after-20260927.log]` Upper-arm poses verified finite and responsive. `[OBSERVED navigation-final-20260927.log]`

### M-04 SkeletonIK3D `[OBSERVED skeleton_ik.tscn:61-77; skeleton_ik_runner.gd]`
Two built-in `SkeletonIK3D` nodes, Left/Right_UpperArm → Left/Right_Hand, targeting `TargetLeft` / `TargetRight` markers; `start(false)` on ready. Responds to mouse input once completed `skeleton_updated` output is sampled. `[OBSERVED FRICTIONAL.md 12:06 UTC; navigation-final-20260927.log]`

### M-05 FPS player `[OBSERVED fps/example_player.gd]`
| Value | Number | Line |
|---|---|---|
| gravity | −38.8 | 4 |
| max / sprint speed | 22 / 34 | 5, 9 |
| accel / sprint accel / decel | 8.5 / 18 / 28 | 7, 10, 12 |
| jump speed | 26 | 6 |
| fire interval / bullet speed | 0.15 s / 100 | 15-16 |
| mouse sensitivity | 0.08 °/px | 25 |
| pitch clamp | −40° … 60° | 212-215 |
| lean | ±20° roll, Q/E, recentres at 1.0/s | 143-164 |
Tuning values, not approved design. `MAX_SLOPE_ANGLE = 40` is declared but never used. `[OBSERVED :13]` Keys are read with `Input.is_key_pressed` (hard-coded W/A/S/D, arrows, Shift, Space, Q, E), not input actions. `[OBSERVED :78-146]` Verified headless: floor contact, W, Shift, Q + recentre, Space, aim FOV 60/80, one bullet spawns, travels, despawns. `[OBSERVED fps-input-20260927.log, 11/11]`

### M-06 Mouse capture and look `[OBSERVED example_player.gd:61, 87-91, 205-217]`
Captured on ready; `ui_cancel` toggles; look only while captured. **Not verified:** the headless backend reads every mouse mode as VISIBLE, so capture, yaw and both pitch clamps fail there (4/8). `[OBSERVED fps-navigation-20260927.log; mouse-backend-20260927.log]` A display is required. (Q-05)

### M-07 Scene chain `[OBSERVED button_change_scene.gd; *.tscn]`
LookAt → FABRIK ⇄ SkeletonIK ⇄ FPS; FABRIK ← back to LookAt. Four GUI transitions plus FPS entry/return verified. `[OBSERVED navigation-final-20260927.log; fps-navigation-20260927.log]`

## 6. Systems

### S-01 Scenes
| Scene | Root | Solver nodes | Lines |
|---|---|---|---|
| `look_at_ik.tscn` (main) | Node3D LookAtIK | 3 × LookAt (Head, L/R UpperArm) | 13-96 |
| `fabrik_ik.tscn` | Node3D FABRIK_IK | LookAt Head, 2 × FABRIK arms, 2 × LookAt hands | 20-204 |
| `skeleton_ik.tscn` | Node3D SkeletonIK3D | LookAt Head, 2 × SkeletonIK3D | 20-139 |
| `fps/fps_example.tscn` | Node3D FPSExample | LookAt Chest / Head / hands, 2 × FABRIK arms, CharacterBody3D player | 168-580 |
| `fps/simple_bullet.tscn` | RigidBody3D | — | 35 lines |

### S-02 Plugin
`addons/sade` — "S.A.D.E (Skeleton3D additions and extensions)" v0.2.0, `plugin_main.gd` registers the two custom nodes; `plugin.cfg` states "All assets are licensed under MIT." `[OBSERVED addons/sade/plugin.cfg]` Whether the plugin is enabled in `project.godot` is not stated (no `[editor_plugins]` section). `[OBSERVED project.godot]` The scripts run as plain node scripts either way `[INFERRED]`; editor-only paths are untested. `[OBSERVED FRICTIONAL.md]`

### S-03 Input map
No `[input]` section. Scenes 1-3 read the raw mouse position; scene 4 polls hard-coded keys and uses built-in `ui_cancel`. `[OBSERVED project.godot; example_player.gd]` Rebinding is impossible without code changes `[INFERRED]` (Q-06).

### S-04 Signals and exports
No custom `signal` declarations. `button_change_scene.gd` connects `pressed` in code (line 7); `example_player.gd` connects `animation_finished` (line 58). Exports: `scene_to_change_to`, `MOVEMENT_SPEED`, `flip_axis`, plus the solver exports in M-02 / M-03.

### S-05 Collision
FPS level: floor + 19 wall StaticBody3D shapes; player CharacterBody3D capsule; bullets RigidBody3D. Default layers. `[OBSERVED fps_example.tscn:170-372, 452-457]`

## 7. Progression
A fixed four-scene sequence, simple → applied. `[OBSERVED M-07]` No unlocks, save or scoring.

## 8. World
Scenes 1-3: a floor, a light and the robot. Scene 4: a walled test yard. `[OBSERVED]` The model README jokes that the robot "really is 14.5 meters tall." `[OBSERVED godot/model/README.md]` That is a scale note, not lore.

## 9. Narrative
None, correctly. `[OBSERVED]`

## 10. Characters
The Godot Battle Bot is a rig, not a character. `[OBSERVED godot/model/]` No personality, name use or story should be added.

## 11. Features and priority

| ID | Feature | Exists | Verified how | Priority |
|---|---|---|---|---|
| F-01 | LookAt scene | yes | 7/7 mouse-input pose checks | [MISSING] |
| F-02 | FABRIK scene | yes | 4 pose checks + transitions | [MISSING] |
| F-03 | SkeletonIK3D scene | yes | 4 pose checks (evaluated sampling) | [MISSING] |
| F-04 | FPS movement / lean / jump / aim / fire | yes | 11/11 headless | [MISSING] |
| F-05 | FPS mouse capture + look clamps | yes | **fails headless — backend limitation** | [MISSING] |
| F-06 | Scene chain | yes | 4 transitions + FPS entry/return | [MISSING] |
| F-07 | FABRIK physics-mode fix | yes (Walker edit) | 8/8 setter fixture | [MISSING] |
| F-08 | Editor-only / `@tool` paths | yes | untested | [MISSING] |
| F-09 | Visible capture + two Liam films | **no** (proposed) | — | [MISSING] |

CORE percentage undetermined (Q-07).

## 12. Out of scope
Observed absences: targets, damage, hit reaction, enemies, audio playback claims, HUD beyond a crosshair, settings, save. `[OBSERVED]` No IK accuracy against an anatomical target has been measured. `[OBSERVED README.md]`

## 13. Technical
- Godot 4.7 tag `[OBSERVED project.godot:19]`; 4.7.2.stable in logs. Renderer unset → Forward+ default; upstream README says Forward+. `[INFERRED]`
- No rendering overrides; stretch `canvas_items` / `expand`. `[OBSERVED project.godot]`
- Scripts: 3 scene helpers, 2 FPS scripts, 3 plugin scripts, 6 Walker test scripts (`test_look`, `test_navigation`, `test_modes`, `test_fps`, `test_fps_navigation`, `test_mouse_backend`).
- Assets: `model/godot_battle_bot.dae` + 2 textures + 2 materials; `fps/weapon_pistol.dae` + texture + 2 materials. DAE headers name author "Anonymous" and an exporter; exporter authorship is not model authorship; asset-specific provenance review pending. `[OBSERVED FRICTIONAL.md 13:06 UTC]` (Q-03)
- 13 log files at the folder root, including failed runs kept as evidence.

## 14. Risks

| ID | Risk | L / I | Evidence |
|---|---|---|---|
| R-01 | FPS mouse-look shown or claimed without display verification | M / H | 4/8 headless fails; backend limitation |
| R-02 | Robot / pistol models published without confirmed licence | M / H | provenance review pending |
| R-03 | The FPS scene read as "a game," inviting feature creep (targets, enemies) | M / M | game-shaped verbs, no goal |
| R-04 | Save-time FABRIK errors appear on camera in the editor | M / L | `fabrik_ik.tscn:129-131` |
| R-05 | Recording blocker holds both films | H / H | README |

**Top 3.** R-05 blocks visible work; R-02 is the obligation; R-01 is the claim a first-person film would make first.

## 15. Open questions
In `decisions.md`: Q-01 film purpose; Q-02 pillars; Q-03 model provenance; Q-04 upstream the FABRIK fix?; Q-05 display verification of mouse-look; Q-06 hard-coded FPS keys; Q-07 CORE; Q-08 FPS scene scope.

## 16. Tests

Existing `[OBSERVED]`:
| ID | Suite | Checks | Result |
|---|---|---|---|
| T-01 | `test_look.gd` | targets move; Head, L/R UpperArm finite + rotate | 7/7 |
| T-02 | `test_navigation.gd` | 4 GUI transitions; FABRIK + SkeletonIK upper-arm finite + respond | 12/12 (final); earlier 10/12 kept |
| T-03 | `test_modes.gd` | update_mode scheduling, both solver scripts, 4 modes | 8/8 after fix; 7/8 before |
| T-04 | `test_fps.gd` | floor, W, Shift, Q + recentre, Space, aim FOV 60/80, bullet spawn/travel/despawn | 11/11 |
| T-05 | `test_fps_navigation.gd` | FPS entry/return, Escape frees mouse, free cursor no turn; capture/yaw/pitch clamps | 4/8 — capture checks fail on headless backend |
| T-06 | `test_mouse_backend.gd` | requested vs observed mouse modes | diagnostic: all read back 0 |

Proposed (dashed):
| ID | Setup | Action | Expected | Links |
|---|---|---|---|---|
| T-07 | display-enabled run | enter FPS | mouse captured; 100 px drag yaws; pitch stops at −40 / 60 | F-05 |
| T-08 | FABRIK scene, visible | sweep mouse | hands reach target without flipping | F-02 |
| T-09 | SkeletonIK vs FABRIK, matched cursor path | capture both | side-by-side for PX-01 | F-02, F-03 |
| H-01 | human viewer | uncoached | can name which solver is which | PX-01? |

## Zelda's notes (silent mode; what I would have said out loud)

7 Failure Mode read:
1. **Ghost Center — PRESENT, expected.**
2. **Mechanic Mirage — ABSENT by refusal.** PX-01/02 are marked unconfirmed.
3. **Implementation Void — PARTIAL.** The strongest test record in this batch, and the one gap is the one a first-person film opens on: mouse-look.
4. **Priority Inflation — cannot assess.**
5. **Novelist's Trap — ABSENT.** "Battle Bot" is a model name. Leave it there.
6. **Completeness Fallacy — PRESENT.** Eight open questions.
7. **Stagnant Artifact — ABSENT.** FRICTIONAL.md is thorough and keeps its failures.

What the structure suggests `[INFERRED]`: a tutorial ladder — watch a bone look, watch a chain reach, compare the engine's solver, then feel it in first person. The FPS scene is the reward, not the product.

**First fix:** Q-08 before anything else. The FPS sandbox is the scene most likely to grow into a game by accident; decide now that it stays a showcase, or say out loud that it is becoming a game and start a real brief.
