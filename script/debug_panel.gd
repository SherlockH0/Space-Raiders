extends CanvasLayer

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_debug"):
		Global.debug = not Global.debug
