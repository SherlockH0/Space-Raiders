extends Node3D
class_name SpaceshipMovementComponent

@export var physics_body: CharacterBody3D
@export var body: Node3D

@export var min_flight_speed = 1
@export var max_flight_speed = 30

@export var acceleration: float = 6.0

var forward_speed: float = 0.0
var throttle_delta = 30

# @export var turn_input = 0.75
# @export var pitch_input = 0.5
# @export var turn_speed = 0.75
# @export var pitch_speed = 0.5
# @export var level_speed = 3.0


func accelerate(direction: int, delta: float) -> void:
	var target_speed: float = min(
		forward_speed + direction * throttle_delta * delta, max_flight_speed
	)
	forward_speed = lerp(forward_speed, target_speed, acceleration * delta)
	physics_body.velocity = -physics_body.transform.basis.z * forward_speed
