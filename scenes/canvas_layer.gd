extends CanvasLayer

@export var player: Node3D
@onready var planet_list = $PlanetList

var planets: Dictionary


func _ready() -> void:
	Global.planet_on_screen.connect(_on_planet_entered)
	Global.planet_off_screen.connect(_on_planet_exited)


func _process(delta: float) -> void:
	var to_erase = []
	for planet in planets:
		var l = planets[planet][1]
		var p = planets[planet][0]
		if p:
			l.text = (
				"%s %sm" % [p.label, int(player.global_position.distance_to(p.global_position))]
			)
			l.position = get_viewport().get_camera_3d().unproject_position(
				p.global_transform.origin
			)
		else:
			to_erase.append(planet)

	for erasable in to_erase:
		planets.erase(erasable)


func _on_planet_entered(planet: Node3D):
	var label = Label.new()
	planet_list.add_child(label)
	planets[str(planet)] = [planet, label]


func _on_planet_exited(planet: Node3D):
	var p = planets[str(planet)]
	p[1].queue_free()
	planets.erase(str(planet))
