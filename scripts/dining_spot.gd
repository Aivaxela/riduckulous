extends Node2D

@export var drake_sprite: Sprite2D
@export var hen_sprite: Sprite2D
@export var release_timer: Timer
@export var release_point: float

var drake_spot_taken: bool = false
var hen_spot_taken: bool = false
var release_timer_active: bool = false
var release_path: Path2D


func _ready():
	release_timer.timeout.connect(_on_release_timer_timeout)

func _process(_delta):
	drake_sprite.visible = drake_spot_taken
	hen_sprite.visible = hen_spot_taken

	if drake_spot_taken and hen_spot_taken and !release_timer_active:
		release_timer.start()
		release_timer_active = true

func _on_release_timer_timeout():
	drake_spot_taken = false
	hen_spot_taken = false
	release_timer_active = false
	var paths = get_tree().get_nodes_in_group("path")
	if paths.size() > 0:
		release_path = paths[randi_range(0, paths.size() - 1)]
	var speed = randf_range(0.02, 0.05)
	release_path.spawn_duck("drake", release_point, speed)
	await get_tree().create_timer(0.35).timeout
	release_path.spawn_duck("hen", release_point, speed)
	get_node("/root/main").drake_count -= 1
	get_node("/root/main").hen_count -= 1
