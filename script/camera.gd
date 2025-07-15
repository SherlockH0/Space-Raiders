extends Camera3D

@export var player: RigidBody3D

@export_group("Speed effect")
@export var default_fov: int = 85
@export var max_fov: int = 110
@export var fov_smoothing_weight: float = 1


func _process(delta: float) -> void:
	speed_effect(delta)


func speed_effect(delta: float) -> void:
	var target_fov: float
	if player.forward_velocity <= 0:
		target_fov = default_fov
	else:
		target_fov = lerp(default_fov, max_fov, player.forward_velocity / 20)
	fov = lerp(fov, target_fov, delta * fov_smoothing_weight)
