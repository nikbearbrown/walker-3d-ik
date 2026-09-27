extends SceneTree
func _initialize():
	print("DIAG display backend: ",DisplayServer.get_name())
	var original := Input.mouse_mode
	for mode in [Input.MOUSE_MODE_VISIBLE,Input.MOUSE_MODE_CAPTURED,Input.MOUSE_MODE_HIDDEN]:
		Input.mouse_mode = mode
		print("DIAG requested ",mode," observed ",Input.mouse_mode)
	Input.mouse_mode = original
	quit()
