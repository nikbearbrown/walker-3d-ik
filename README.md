# Walker — 3D Inverse Kinematics

**What this is.** An independent local copy of the official Godot demo `3d/ik`:
four linked scenes that pose the same robot rig (the Godot Battle Bot) with
inverse kinematics — LookAt, the script-based FABRIK solver from the bundled
S.A.D.E plugin, Godot's built-in `SkeletonIK3D`, and an FPS example where IK
drives the robot's arms around a pistol while you move, lean, aim and fire. It
is a tech demo; the FPS scene has player controls but no targets, objective or
score, so it is a showcase, not a game.

**Why it is in Walker.** It is one of Walker's Godot demo adaptations and the
source for two planned Liam films.

**What was found and verified.** Godot 4.7.2 headless import/startup pass.
Headless state checks pass for LookAt target and pose response (7), scene
navigation with FABRIK and SkeletonIK arm response (12), solver update modes
after the local FABRIK fix (8), and FPS input (11). FPS mouse capture, mouse
look and pitch clamps are not verified: the headless backend cannot capture
the mouse. Nothing here establishes rendered quality, accurate anatomical
targeting or human playability.

## How to run

Open `godot/project.godot` in Godot 4.7 and run the main scene
(`look_at_ik.tscn`). Use the Next scene / Previous scene buttons to move
between LookAt → FABRIK → SkeletonIK3D → FPS example.

Controls (from the source):

- LookAt, FABRIK and SkeletonIK3D scenes: move the mouse to move the IK targets
- FPS example: W/A/S/D or arrows to move, Shift to sprint, Space to jump,
  Q/E to lean left/right, left click to fire, right click to look down the
  sights, Escape to free/lock the mouse cursor

## Design

- [GDD.md](GDD.md) — recovered game design document (identical copy of
  `design/GDD.md`)
- [design/DECK.html](design/DECK.html) — review slides
- [design/IMPLEMENTATION-MAP.md](design/IMPLEMENTATION-MAP.md) — feature → scene/script/line
- [design/decisions.md](design/decisions.md) — open questions

The GDD was recovered from the code by Walker's Zelda GDD skill
(`/gdd reverse`, silent). It describes what exists; it is not an approved
design, and every gate is unsigned.

## Source & license

Upstream: `3d/ik` from Godot demos commit
`a3b5c113112f77291d5f3d1360f33a882fdc52f7`. Original README, model notes,
assets, UIDs and root MIT `LICENSE.md` retained. Production edits: title and
FABRIK scheduling correction (physics mode now enables physics processing).
Model-specific attribution for the robot and pistol is still under review.

## Status

Godot 4.7.2 headless import/startup pass. `test_look.gd` sends a mouse-motion
event through `Input.parse_input_event` in the actual LookAt scene. Seven checks
pass for target movement and finite/changed head and upper-arm bone poses.
This does not establish rendered quality, accurate anatomical targeting, or
human playability. No footage or completed films yet.

FPS input test passes 11 checks for movement/sprint/jump/lean, aim FOV toggling,
bullet spawn/travel and natural despawn. See `fps-input-20260927.log`. These
remain headless state checks, not inspected gameplay capture.

Navigation test now passes 12 assertions: four GUI transitions and
finite/changed arm poses for FABRIK and SkeletonIK. Earlier two failures were
resolved by sampling completed `skeleton_updated` output instead of polling
between updates. See `FRICTIONAL.md`; rendered appearance and remaining scenes
are not fully verified.

FPS entry/return GUI transitions pass. Captured mouse-look and pitch clamps
remain unverified: headless backend reads mouse mode as VISIBLE even after a
CAPTURED request, independently reproduced without gameplay. Failed tests retained.

Next: inspect/test editor-only paths and model-specific attribution. Both Liam
films remain pending the existing capture constraint; no visible recording
windows were reopened.

Repository: https://github.com/nikbearbrown/walker-3d-ik
