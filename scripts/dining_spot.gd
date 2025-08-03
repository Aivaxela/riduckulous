extends Node2D

@export var drake_sprite: Sprite2D
@export var hen_sprite: Sprite2D
@export var bread_sprite: Sprite2D
@export var wine_sprite: Sprite2D	
@export var release_timer: Timer
@export var angry_release_timer: Timer
@export var release_point: float
@export var food_collect_area: Area2D
@export var progress_bar: TextureProgressBar
@export var candles: GPUParticles2D

var drake_spot_taken: bool = false
var hen_spot_taken: bool = false
var wine_collected: bool = false
var bread_collected: bool = false
var release_timer_active: bool = false
var release_path: Path2D


func _ready():
	release_timer.timeout.connect(_on_release_timer_timeout)
	food_collect_area.area_entered.connect(_on_food_collect_area_entered)
	angry_release_timer.timeout.connect(_on_angry_release_timer_timeout)
	progress_bar.max_value = angry_release_timer.wait_time
	progress_bar.value = 0
	progress_bar.visible = false

func _process(_delta):
	drake_sprite.visible = drake_spot_taken
	hen_sprite.visible = hen_spot_taken
	wine_sprite.visible = wine_collected
	bread_sprite.visible = bread_collected
	if angry_release_timer.time_left > 0:
		progress_bar.value = angry_release_timer.time_left
		progress_bar.visible = true
	else:
		progress_bar.visible = false
	
	if (drake_spot_taken or hen_spot_taken) and not (drake_spot_taken and hen_spot_taken):
		if not angry_release_timer.time_left > 0 and not release_timer_active:
			angry_release_timer.start()
	
	if drake_spot_taken and hen_spot_taken and not release_timer_active:
		if not angry_release_timer.time_left > 0:
			angry_release_timer.start()
	
	if drake_spot_taken and hen_spot_taken and !release_timer_active and wine_collected and bread_collected:
		angry_release_timer.stop()
		release_timer.start()
		release_timer_active = true
		candles.emitting = true

func _on_release_timer_timeout():
	drake_spot_taken = false
	hen_spot_taken = false
	wine_collected = false
	bread_collected = false
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
	candles.emitting = false

func _on_angry_release_timer_timeout():
	drake_spot_taken = false
	hen_spot_taken = false
	wine_collected = false
	bread_collected = false
	release_timer_active = false
	get_node("/root/main").drake_count -= 1
	get_node("/root/main").hen_count -= 1
	candles.emitting = false

func _on_food_collect_area_entered(area: Area2D):
	if (area.name == "wine_bomb_explosion" and (drake_spot_taken and hen_spot_taken)):
		wine_collected = true
	elif (area.name == "bread_bomb_explosion" and (drake_spot_taken and hen_spot_taken)):
		bread_collected = true
