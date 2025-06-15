extends CharacterBody3D

@export var bullet: PackedScene

@onready var body: Node3D = $Body
@onready var marker_left: Marker3D = $Body/MarkerLeft
@onready var marker_right: Marker3D = $Body/MarkerRight
@onready var camera: Camera3D = $Camera3D

@export var spaceship_movement: SpaceshipMovementComponent


func _physics_process(delta: float) -> void:
	get_input(delta)
	move_and_slide()


func get_input(delta: float) -> void:
	var direction = Input.get_axis("s", "w")
	spaceship_movement.accelerate(direction, delta)
