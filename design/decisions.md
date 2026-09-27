# Open questions log — walker-3d-ik

Recovered by `/gdd reverse --path godot silent`, 2026-09-27 · gate — unsigned at time of writing. Every `[MISSING]` in `GDD.md` is one row. Nothing below is decided.

Format per entry: THE QUESTION / THE STAKES / DECISION DEADLINE / OPTIONS / OWNER / STATUS.

| # | Question | Stakes | Deadline | Options | Owner | Status |
|---|---|---|---|---|---|---|
| Q-01 | What do the two Liam films teach, and to whom? | IK-as-technique and IK-as-game-feel are different films (Ghost Center) | Before capture | (a) three solvers compared on one rig; (b) procedural first-person arms; (c) one each | Nik Bear Brown | Open |
| Q-02 | Pillars for the Walker adaptation | Nothing to judge shots against | With Q-01 | adopt the three `[INFERRED]` pillars in GDD §2, or replace | Nik Bear Brown | Open |
| Q-03 | Provenance / licence of the robot and pistol models | DAE headers give author "Anonymous"; publication without confirmed terms is a legal exposure | Before any publication | trace upstream asset history; rely on repo MIT with a note; replace models (needs approval) | Nik Bear Brown | Open |
| Q-04 | Offer the FABRIK physics-mode fix upstream? | Local copy now differs from upstream in production code | Before the repo is public | open an upstream issue/PR; keep local only; document in README (done) | Nik Bear Brown | Open |
| Q-05 | Where will mouse-look and pitch clamps be verified? | Headless cannot capture the mouse; a first-person film depends on it | Before any FPS take | display-enabled run on the main Mac; on the Filmloop mini; defer and do not show FPS | Nik Bear Brown | Open |
| Q-06 | FPS keys are hard-coded, not input actions | No rebinding, no gamepad; a "how to build it" film would teach a pattern Walker may not want | Before a build-focused film | leave as upstream sample; convert to actions (touches godot/, needs approval) | Nik Bear Brown | Open |
| Q-07 | Which features are CORE? | CORE % cannot be computed | With Q-01 | mark F-01..F-09 | Nik Bear Brown | Open |
| Q-08 | Does the FPS sandbox stay a showcase? | Game-shaped verbs with no goal invite scope creep (targets, enemies) | Before any new work on scene 4 | freeze as showcase; start a separate game brief (`/gdd v1`) if it is to become a game | Nik Bear Brown | Open |
