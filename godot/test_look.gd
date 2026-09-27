extends SceneTree
var checks := 0
var failures := 0
func _initialize():
	call_deferred("run")
func check(ok: bool, label: String):
	checks += 1
	if not ok: failures += 1
	print("PASS " if ok else "FAIL ", label)
func run():
	root.size = Vector2i(1152,648)
	var scene: Node = load("res://look_at_ik.tscn").instantiate()
	root.add_child(scene)
	await create_timer(0.1).timeout
	var skeleton: Skeleton3D = scene.get_node("GodotBattleBot/Armature/Skeleton3D")
	var targets: Node3D = scene.get_node("Camera3D/Targets")
	var previous := targets.position
	var previous_poses := []
	for bone in ["Head", "Left_UpperArm", "Right_UpperArm"]:
		previous_poses.append(skeleton.get_bone_global_pose(skeleton.find_bone(bone)))
	var event := InputEventMouseMotion.new()
	event.position = Vector2(900,200)
	event.global_position = event.position
	Input.parse_input_event(event)
	await create_timer(0.1).timeout
	check(targets.position.distance_to(previous) > 0.1, "mouse moves targets")
	var i := 0
	for bone in ["Head", "Left_UpperArm", "Right_UpperArm"]:
		var pose := skeleton.get_bone_global_pose(skeleton.find_bone(bone))
		check(pose.is_finite(), bone + " finite pose")
		check(not pose.basis.is_equal_approx(previous_poses[i].basis), bone + " rotates with mouse")
		i += 1
	scene.queue_free()
	await process_frame
	print("RESULT ", checks, " checks; ", failures, " failures")
	quit(1 if failures else 0)
