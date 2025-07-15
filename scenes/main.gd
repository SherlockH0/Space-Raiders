extends Node3D

@export var enemy_scene: PackedScene

@onready var spawn_timer = %SpawnTimer
@onready var player = $Player
@onready var enemies = $Enemies


func _ready():
	randomize()


func _on_spawn_timer_timeout() -> void:
	if enemies.get_child_count() <= 10:
		var enemy = enemy_scene.instantiate()
		enemy.player = player
		enemies.add_child(enemy)
		enemy.global_position = Vector3(
			randf_range(-500, 500), randf_range(-500, 500), randf_range(-500, 500)
		)
