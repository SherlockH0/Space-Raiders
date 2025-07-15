extends VisibleOnScreenNotifier3D

@export var label: String


func _on_screen_exited() -> void:
	Global.planet_off_screen.emit(self)


func _on_screen_entered() -> void:
	Global.planet_on_screen.emit(self)
