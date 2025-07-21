extends Node3D

var player
var speed = 10


@onready var ray: RayCast3D = $RayCast3D

var is_dead := false

func _process(_delta: float) -> void:
	if not is_dead and ray.is_colliding():
		delete()
	position += transform.basis.z * speed


func delete():
	speed = 0
	is_dead = true
	explode()
	var collider = ray.get_collider()
	if collider.has_method("apply_force"):
		var point = collider.to_local(ray.get_collision_point())
		collider.apply_force(global_basis.z, point)
	if collider.has_method("die"):
		collider.die()
	await get_tree().create_timer(2).timeout
	queue_free()


func explode():
	pass

func _on_life_timer_timeout() -> void:
	queue_free()
