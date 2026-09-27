extends SceneTree
func _initialize():
	var failures := 0
	var checks := 0
	# Constructed scheduling fixture; not gameplay or editor visual verification.
	for path in ["res://addons/sade/ik_fabrik.gd", "res://addons/sade/ik_look_at.gd"]:
		var solver: Node3D = load(path).new()
		for mode in range(4):
			solver.update_mode = mode
			var ok: bool = solver.is_processing() == (mode == 0) and solver.is_physics_processing() == (mode == 1) and solver.is_transform_notification_enabled() == (mode == 2)
			checks += 1
			if not ok: failures += 1
			print("PASS " if ok else "FAIL ",path," mode ",mode)
		solver.free()
	print("RESULT ",checks," checks; ",failures," failures")
	quit(1 if failures else 0)
