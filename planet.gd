extends StaticBody3D

var gravitons: Array[Node]
const G = 6.67430 * 10e-5
@export var mass := 10000.0
@export var label: String


func _ready() -> void:
	gravitons = get_tree().get_nodes_in_group("gravitons")


func _physics_process(_delta: float) -> void:
	for graviton in gravitons:
		if not is_instance_of(graviton, RigidBody3D):
			continue
		var direction = graviton.global_position - global_position
		graviton.apply_force(
			(-direction.normalized() * G * mass * graviton.mass) / direction.length_squared()
		)
