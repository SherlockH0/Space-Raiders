extends RigidBody3D

@export var bullet: PackedScene
@export var player: RigidBody3D

@onready var debris = $Debris
@onready var smoke = $Fire
@onready var fire = $Smoke

@onready var body: MeshInstance3D = $Body
@onready var shooting_timer: Timer = $ShootingTimer
@onready var marker_left: Marker3D = $Body/MarkerLeft
@onready var marker_right: Marker3D = $Body/MarkerRight

@onready var ground_ray: RayCast3D = %GroundRay

@export var forward_torque_power := 1.0
@export var side_torque_power := 1.0
@export var rotate_torque := 1.0
@export var thrust_power := 1.0
@export var take_off_power := 1.0

@export var vision_limit := 100.0
@export var min_distance := 10.0

var is_shooting := false
var forward_velocity = 0

var move_up := 0.0
var roll := 0.0
var turn := 0.0
var thrust := 0.0


func _physics_process(delta: float) -> void:
	var distance_to_player = global_position.distance_to(player.global_position)
	if distance_to_player <= vision_limit:
		look_at(player.global_position)
		if shooting_timer.is_stopped():
			is_shooting = true
			shooting_timer.start()
		if distance_to_player > min_distance:
			thrust = -1
		else:
			thrust = 0
	else:
		is_shooting = false
		thrust = 0
	# apply_torque(transform.basis.x * move_up * forward_torque_power * delta)
	# apply_torque(transform.basis.y * roll * side_torque_power * delta)
	# apply_torque(transform.basis.z * turn * rotate_torque * delta)

	apply_central_force(transform.basis.z * thrust * thrust_power)


func die():
	explode()
	await get_tree().create_timer(2).timeout
	queue_free()


func explode():
	body.visible = false
	debris.emitting = true
	smoke.emitting = true
	fire.emitting = true


func push():
	var b_left = bullet.instantiate()
	var b_right = bullet.instantiate()
	b_left.player = self
	b_right.player = self
	b_left.global_transform = marker_left.global_transform
	b_right.global_transform = marker_right.global_transform
	get_tree().root.add_child(b_left)
	get_tree().root.add_child(b_right)


func _on_shooting_timer_timeout() -> void:
	if is_shooting:
		shooting_timer.start()
		push()
