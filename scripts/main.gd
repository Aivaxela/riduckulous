extends Node

@export var volume_slider: HSlider
@export var egg_scene: PackedScene
@export var pond_duck: PackedScene
@export var duck_pond_spawn_point: Marker2D
@export var drake_count_label: Label
@export var hen_count_label: Label

var drake_count: int = 0
var hen_count: int = 0
var egg_count: int = 10

func _ready():
	volume_slider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	volume_slider.value_changed.connect(_on_vol_slider_value_changed)

func _process(_delta):
	drake_count_label.text = "Drakes: " + str(drake_count)
	hen_count_label.text = "Hens: " + str(hen_count)

func decide_duck_gender() -> String:
	if drake_count < hen_count:
		return "drake"
	elif hen_count < drake_count:
		return "hen"
	else:
		return "drake" if randf() < 0.5 else "hen"

func spawn_egg(amount: int):
	var egg_spawn_points = get_tree().get_nodes_in_group("egg_spawn")
	var egg_spawn_point: Marker2D = egg_spawn_points[randi_range(0, egg_spawn_points.size() - 1)]
	for i in range(amount):
		var egg: Node2D = egg_scene.instantiate()
		var position_variation = Vector2(randf_range(-4, 4), randf_range(-4, 4))
		egg.global_position = egg_spawn_point.global_position + position_variation
		call_deferred("add_child", egg)

func add_duck_to_pond(duck_type: String):
	call_deferred("add_duck_deferred", duck_type)

func add_duck_deferred(duck_type: String):
	var new_duck = pond_duck.instantiate()
	duck_pond_spawn_point.add_child(new_duck)
	new_duck.global_position = duck_pond_spawn_point.global_position
	new_duck.animated_sprite.play(duck_type)

func _on_vol_slider_value_changed(_value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume_slider.value)
