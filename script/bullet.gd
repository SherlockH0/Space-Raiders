extends Area3D

var player
var speed = 3

@onready var mesh: MeshInstance3D = $MeshInstance3D2

func _process(_delta: float) -> void:
	position -= transform.basis.z * speed

func _on_timer_timeout() -> void:
	queue_free()

func delete():
	mesh.visible = true
	speed = 0
	await get_tree().create_timer(2).timeout
	queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body != player:
		delete()
