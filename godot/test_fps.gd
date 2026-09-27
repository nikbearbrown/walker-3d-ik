extends SceneTree
var checks := 0
var failures := 0
func _initialize():
	call_deferred("run")
func check(ok: bool, label: String):
	checks += 1
	if not ok: failures += 1
	print("PASS " if ok else "FAIL ",label)
func key(k: int, down: bool):
	var e := InputEventKey.new()
	e.keycode = k
	e.pressed = down
	Input.parse_input_event(e)
func mouse(b: int, down: bool):
	var e := InputEventMouseButton.new()
	e.button_index = b
	e.pressed = down
	Input.parse_input_event(e)
func run():
	root.size = Vector2i(1152,648)
	var scene: Node = load("res://fps/fps_example.tscn").instantiate()
	root.add_child(scene)
	await create_timer(1.2).timeout
	var p: Node = scene.get_node("CharacterBody3D")
	check(p.is_on_floor(),"settles on floor")
	var start: Vector3 = p.position
	key(KEY_W,true)
	await create_timer(0.2).timeout
	check(p.position.distance_to(start) > 1,"W moves player")
	key(KEY_SHIFT,true)
	await create_timer(0.15).timeout
	check(p.is_sprinting,"Shift sprint")
	key(KEY_SHIFT,false)
	key(KEY_W,false)
	key(KEY_Q,true)
	await create_timer(0.15).timeout
	check(p.lean_value > 0.6,"Q leans")
	key(KEY_Q,false)
	await create_timer(0.3).timeout
	check(is_equal_approx(p.lean_value,0.5),"lean recenters")
	key(KEY_SPACE,true)
	await create_timer(0.1).timeout
	key(KEY_SPACE,false)
	check(not p.is_on_floor() and p.vel.y > 0,"Space jumps")
	mouse(MOUSE_BUTTON_RIGHT,true)
	await create_timer(0.05).timeout
	mouse(MOUSE_BUTTON_RIGHT,false)
	await create_timer(1.1).timeout
	check(p.current_anim == "Aiming" and is_equal_approx(p.camera.fov,60),"right click aims FOV60")
	mouse(MOUSE_BUTTON_RIGHT,true)
	await create_timer(0.05).timeout
	mouse(MOUSE_BUTTON_RIGHT,false)
	await create_timer(1.1).timeout
	check(p.current_anim == "Idle" and is_equal_approx(p.camera.fov,80),"right click restores FOV80")
	mouse(MOUSE_BUTTON_LEFT,true)
	await create_timer(0.08).timeout
	mouse(MOUSE_BUTTON_LEFT,false)
	var bullets := root.get_children().filter(func(n): return n is RigidBody3D)
	check(bullets.size() == 1,"left click spawns one bullet")
	if bullets.size() == 1:
		check(bullets[0].linear_velocity.length() > 1,"bullet travels")
	await create_timer(5.2).timeout
	check(root.get_children().filter(func(n): return n is RigidBody3D).is_empty(),"bullet naturally despawns")
	scene.queue_free()
	await process_frame
	print("RESULT ",checks," checks; ",failures," failures")
	quit(1 if failures else 0)
