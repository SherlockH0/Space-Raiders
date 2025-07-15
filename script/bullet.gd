extends Node3D

var player
var speed = 3

@onready var ray: RayCast3D = $RayCast3D
@onready var debris = $Debris
@onready var smoke = $Fire
@onready var fire = $Smoke


func _process(_delta: float) -> void:
	if ray.is_colliding():
		delete()
	position += transform.basis.z * speed


func delete():
	speed = 0
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
	$MeshInstance3D.visible = false
	debris.emitting = true
	smoke.emitting = true
	fire.emitting = true


func _on_body_entered(body: Node3D) -> void:
	if body != player:
		delete()


func _on_life_timer_timeout() -> void:
	queue_free()
