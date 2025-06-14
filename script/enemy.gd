extends CharacterBody3D

var min_flight_speed = 1
var max_flight_speed = 30
var turn_speed = 0.75
var pitch_speed = 0.5
var level_speed = 3.0
var throttle_delta = 30
var acceleration: float = 6.0
var forward_speed: float = 0.0
var target_speed: float = 0.0
var turn_input = 0.75
var pitch_input = 0.5

@export var player: CharacterBody3D
@export var bullet: PackedScene

@onready var body: Node3D = $Body
@onready var marker_left: Marker3D = $Body/MarkerLeft
@onready var marker_right: Marker3D = $Body/MarkerRight

func _physics_process(delta: float) -> void:
	get_input(delta)
	body.rotation.z = lerp(body.rotation.y, turn_input, level_speed * delta * 20)
	transform.basis = transform.basis.rotated(transform.basis.x, pitch_input * pitch_speed * delta)
	transform.basis = transform.basis.rotated(Vector3.UP, turn_input * turn_speed * delta)
	forward_speed = lerp(forward_speed, target_speed, acceleration * delta)
	velocity = -transform.basis.z * forward_speed
	#if Input.is_action_just_pressed("ui_accept"):
		#push()
	move_and_slide()

func get_input(delta):
	target_speed = min(forward_speed + throttle_delta * delta, max_flight_speed)
	if (position.x - player.position.x) < 0:
		turn_input = -1.0
	if (position.x - player.position.x) > 0:
		turn_input = 1.0

	if (position.y - player.position.y) > 0:
		pitch_input = -1
	if (position.y - player.position.y) < 0:
		pitch_input = 1

#func push():
	#var b_left = bullet.instantiate()
	#var b_right = bullet.instantiate()
	#b_left.player = self
	#b_right.player = self
	#b_left.global_transform = marker_left.global_transform
	#b_right.global_transform = marker_right.global_transform
	#get_tree().root.add_child(b_left)
	#get_tree().root.add_child(b_right)
