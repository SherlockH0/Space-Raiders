extends Node3D

@export var enemy_scene: PackedScene
@export var player_scene: PackedScene

@onready var spawn_timer = %SpawnTimer
@onready var enemies = $Enemies
@onready var multiplayer_controller: Control = $CanvasLayer/MultiplayerController
@onready var spawn_root: Node = $SpawnRoot

var peer = ENetMultiplayerPeer.new()

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	randomize()


func _on_spawn_timer_timeout() -> void:
	if enemies.get_child_count() <= 10:
		var enemy = enemy_scene.instantiate()
		enemy.player = spawn_root.get_child(0)
		enemy.start_game = true
		enemies.add_child(enemy)
		enemy.global_position = Vector3(
			randf_range(-500, 500), randf_range(-500, 500), randf_range(-500, 500)
		)

func _on_join_pressed() -> void:
	peer.create_client("127.0.0.1", 1027)
	multiplayer.multiplayer_peer = peer
	multiplayer_controller.hide()

func _on_host_pressed() -> void:
	peer.create_server(1027)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player()
	multiplayer_controller.hide()

func add_player(id = 1) -> void:
	var add_scene = player_scene.instantiate()
	add_scene.name = str(id)
	spawn_root.add_child(add_scene)

func exit_game(id):
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)

func del_player(id):
	rpc("_de_player", id)

@rpc("call_local", "any_peer")
func _del_player(id):
	get_node(str(id)).queue_free()
