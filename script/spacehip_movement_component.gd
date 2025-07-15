extends Node3D
class_name SpaceshipMovementComponent

@export var physics_body: CharacterBody3D
@export var body: Node3D

@export var min_flight_speed: float = 1.0
@export var max_flight_speed: float = 30.0

@export var acceleration: float = 10.0

var forward_speed: float = 0.0
var throttle_delta: float = 30.0

@export var turn_speed = 20.75
@export var level_speed = 30.0
@export var pitch_speed = 10.0

var acceleration_direction: float = 0.0
var turn_input: float = 0.0
var pitch_input: float = 0.0

var direction: Vector2 = Vector2.ZERO

var rotation_speed: float = 5.0

# Reference to the spaceship's current rotation
var current_rotation: Quaternion


func _physics_process(delta):
	var yaw_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	var pitch_input = Input.get_action_strength("up") - Input.get_action_strength("down")
	var roll_input = (
		Input.get_action_strength("roll_right") - Input.get_action_strength("roll_left")
	)

	# Create quaternions for each axis
	var yaw_quat = Quaternion(Vector3.UP, yaw_input * rotation_speed * delta)
	var pitch_quat = Quaternion(Vector3.RIGHT, pitch_input * rotation_speed * delta)
	var roll_quat = Quaternion(Vector3.FORWARD, roll_input * rotation_speed * delta)

	# Combine the rotations
	current_rotation = current_rotation * yaw_quat * pitch_quat * roll_quat

	# Normalize the quaternion to avoid drift
	current_rotation = current_rotation.normalized()

	# Apply the rotation to the spaceship
	physics_body.quaternion = current_rotation


func accelerate(_direction: float) -> void:
	acceleration_direction = _direction


func turn(input: float) -> void:
	turn_input = input


func pitch(input: float) -> void:
	pitch_input = input


func get_input(input: Vector2) -> void:
	direction = input
