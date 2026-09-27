extends SceneTree
var checks := 0
var failures := 0
var evaluated := []
var evaluations := 0
func snapshot(sk: Skeleton3D):
	evaluated = []
	for b in ["Left_UpperArm", "Right_UpperArm"]:
		evaluated.append(sk.get_bone_global_pose(sk.find_bone(b)))
	evaluations += 1
func _initialize():
	call_deferred("run")
func check(ok: bool, label: String):
	checks += 1
	if not ok: failures += 1
	print("PASS " if ok else "FAIL ", label)
func navigate(button: String, expected: String):
	current_scene.get_node("Control/" + button).grab_focus()
	var e := InputEventKey.new()
	e.keycode = KEY_ENTER
	e.pressed = true
	root.push_input(e)
	await process_frame
	e = InputEventKey.new()
	e.keycode = KEY_ENTER
	root.push_input(e)
	await create_timer(0.15).timeout
	check(current_scene.scene_file_path == expected, "GUI transition " + expected)
func move_target():
	var sk: Skeleton3D = current_scene.get_node("GodotBattleBot/Armature/Skeleton3D")
	# Sample completed modifier output, not the restored base pose between updates.
	# --raw preserves the original diagnostic sampling for comparison.
	var use_evaluated := not OS.get_cmdline_user_args().has("--raw")
	evaluated = []
	evaluations = 0
	if use_evaluated:
		sk.skeleton_updated.connect(snapshot.bind(sk))
		await create_timer(0.1).timeout
		print("DIAG skeleton_updated samples ",evaluations)
	var before := []
	var target_before: Vector3 = current_scene.get_node("Camera3D/Targets").position
	for b in ["Left_UpperArm", "Right_UpperArm"]:
		before.append(sk.get_bone_global_pose(sk.find_bone(b)))
	if use_evaluated and evaluated.size() == 2:
		before = evaluated.duplicate()
	var e := InputEventMouseMotion.new()
	e.position = Vector2(850,180)
	e.global_position = e.position
	Input.parse_input_event(e)
	await create_timer(0.15).timeout
	print("DIAG ",current_scene.name," target ",target_before," -> ",current_scene.get_node("Camera3D/Targets").position)
	if sk.has_node("SkeletonIK_Left"):
		print("DIAG solvers running: ",sk.get_node("SkeletonIK_Left").is_running()," / ",sk.get_node("SkeletonIK_Right").is_running())
	var i := 0
	for b in ["Left_UpperArm", "Right_UpperArm"]:
		var pose := sk.get_bone_global_pose(sk.find_bone(b))
		if use_evaluated and evaluated.size() == 2:
			pose = evaluated[i]
		check(pose.is_finite(), current_scene.name + " " + b + " finite")
		check(not pose.basis.is_equal_approx(before[i].basis), current_scene.name + " " + b + " responds")
		i += 1
func run():
	root.size = Vector2i(1152,648)
	change_scene_to_file("res://look_at_ik.tscn")
	await create_timer(0.15).timeout
	await navigate("ButtonNext", "res://fabrik_ik.tscn")
	await move_target()
	# Reset mouse through an input event before loading the next scene.
	var e := InputEventMouseMotion.new()
	e.position = Vector2(300,400)
	e.global_position = e.position
	Input.parse_input_event(e)
	await navigate("ButtonNext", "res://skeleton_ik.tscn")
	await move_target()
	await navigate("ButtonPrev", "res://fabrik_ik.tscn")
	await navigate("ButtonPrev", "res://look_at_ik.tscn")
	current_scene.queue_free()
	await process_frame
	print("RESULT ",checks," checks; ",failures," failures")
	quit(1 if failures else 0)
