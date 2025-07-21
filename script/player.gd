extends RigidBody3D

@export var bullet: PackedScene

@onready var body: MeshInstance3D = $Body
@onready var speed_label: ProgressBar = %Speed
@onready var shooting_timer: Timer = $ShootingTimer
@onready var marker_left: Marker3D = %LeftGun
@onready var marker_right: Marker3D = %RightGun
@onready var health_label: ProgressBar = $CanvasLayer/Health

@onready var camera_target: Marker3D = $CameraTarget

@onready var ground_ray: RayCast3D = %GroundRay

var pos := Vector2.ZERO
var health = 30
var move_up := 0.0
var roll := 0.0

@export var forward_torque_power := 1.0
@export var side_torque_power := 1.0
@export var rotate_torque := 1.0
@export var thrust_power := 1.0
@export var take_off_power := 1.0
var forward_velocity = 0


func _ready():
	health_label.value = 0
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta: float) -> void:
	if health <= 0:
		get_tree().reload_current_scene()
	forward_velocity = -transform.basis.z.dot(linear_velocity)
	speed_label.value = 30 - forward_velocity
	var turn = -Input.get_axis("left", "right")
	var take_off = Input.get_axis("land", "take_off")

	if not ground_ray.is_colliding():
		apply_torque(transform.basis.x * move_up * forward_torque_power * delta)
		apply_torque(transform.basis.y * roll * side_torque_power * delta)
		apply_torque(transform.basis.z * turn * rotate_torque * delta)

		apply_central_force(transform.basis.z * Input.get_axis("up", "down") * thrust_power)
	apply_central_force(transform.basis.y * take_off * take_off_power)

	move_up = 0
	roll = 0

	if Input.is_action_pressed("shoot"):
		if shooting_timer.is_stopped():
			shooting_timer.start()
			push()

# func get_input() -> void:
# 	var direction = Input.get_axis("s", "w")
# 	spaceship_movement.accelerate(direction)
func push():
	var b_left = bullet.instantiate()
	var b_right = bullet.instantiate()
	b_left.player = self
	b_right.player = self
	b_left.global_transform = marker_left.global_transform
	b_right.global_transform = marker_right.global_transform
	get_tree().root.add_child(b_left)
	get_tree().root.add_child(b_right)

func _input(event: InputEvent) -> void:
	if is_instance_of(event, InputEventMouseMotion):
		var mouse_event: InputEventMouseMotion = event
		pos = mouse_event.relative

		roll = -pos.x / 100
		move_up = -pos.y / 100

func _on_shooting_timer_timeout() -> void:
	if Input.is_action_pressed("shoot"):
		shooting_timer.start()
		push()

func die():
	health -= 10
	health_label.value = 30 - health
