extends SceneTree
var checks := 0
var failures := 0
func _initialize():
	call_deferred("run")
func check(ok: bool, label: String):
	checks += 1
	if not ok: failures += 1
	print("PASS " if ok else "FAIL ", label)
func key(k: int, down: bool):
	var e := InputEventKey.new()
	e.keycode = k
	e.pressed = down
	Input.parse_input_event(e)
func motion(relative: Vector2):
	var e := InputEventMouseMotion.new()
	e.screen_relative = relative
	e.relative = relative
	Input.parse_input_event(e)
func run():
	root.size = Vector2i(1152,648)
	change_scene_to_file("res://skeleton_ik.tscn")
	await create_timer(0.15).timeout
	current_scene.get_node("Control/ButtonNext").grab_focus()
	key(KEY_ENTER,true)
	await process_frame
	key(KEY_ENTER,false)
	await create_timer(0.2).timeout
	check(current_scene.scene_file_path == "res://fps/fps_example.tscn", "Enter enters FPS")
	var p: Node = current_scene.get_node("CharacterBody3D")
	check(Input.mouse_mode == Input.MOUSE_MODE_CAPTURED,"FPS captures mouse mode")
	var yaw: float = p.rotation.y
	motion(Vector2(100,10000))
	await process_frame
	check(not is_equal_approx(p.rotation.y,yaw),"mouse changes yaw")
	check(is_equal_approx(p.camera_holder.rotation_degrees.x,60),"upper pitch clamp60")
	motion(Vector2(0,-10000))
	await process_frame
	check(is_equal_approx(p.camera_holder.rotation_degrees.x,-40),"lower pitch clamp-40")
	key(KEY_ESCAPE,true)
	await create_timer(0.05).timeout
	key(KEY_ESCAPE,false)
	check(Input.mouse_mode == Input.MOUSE_MODE_VISIBLE,"Escape frees mouse mode")
	yaw = p.rotation.y
	motion(Vector2(100,0))
	await process_frame
	check(is_equal_approx(yaw,p.rotation.y),"free cursor does not turn player")
	current_scene.get_node("Control/ButtonPrev").grab_focus()
	key(KEY_ENTER,true)
	await process_frame
	key(KEY_ENTER,false)
	await create_timer(0.15).timeout
	check(current_scene.scene_file_path == "res://skeleton_ik.tscn","Enter returns to SkeletonIK")
	current_scene.queue_free()
	await process_frame
	print("RESULT ",checks," checks; ",failures," failures")
	quit(1 if failures else 0)
