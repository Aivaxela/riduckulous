extends PathFollow2D

@export var speed = 0.05
@export var quack_sfx: AudioStreamPlayer
@export var quack_timer: Timer
@export var quack_label_scene: PackedScene
@export var duck_sprite: Sprite2D
@export var duck_sprites: Array[CompressedTexture2D]
@export var duck_area: Area2D

var parent: Path2D
var loop_progress_tracker: float = 0.00
enum DuckState {DUCKLING, JUVENILE, ADULT}
var current_state: DuckState = DuckState.DUCKLING


func _ready():
	parent = get_parent()
	quack_timer.timeout.connect(_on_quack_timer_timeout)
	duck_area.area_entered.connect(_on_area_entered)
	quack_timer.wait_time = randi_range(1, 2)
	quack_timer.start()
	quack_sfx.pitch_scale = randf_range(0.9, 1.5)
	duck_sprite.texture = duck_sprites[0]

func _process(_delta):
	rotation = 0
	duck_sprite.flip_h = progress_ratio > parent.sprite_flip_thresholds[0] && progress_ratio < parent.sprite_flip_thresholds[1]
	match current_state:
		DuckState.DUCKLING:
			process_duckling()
		DuckState.JUVENILE:
			process_juvenile()
		DuckState.ADULT:
			process_adult()
			
func _physics_process(delta):
	match current_state:
		DuckState.DUCKLING:
			physics_process_duckling(delta)
		DuckState.JUVENILE:
			physics_process_juvenile(delta)
		DuckState.ADULT:
			physics_process_adult(delta)
	
	
	#spawns duck when loop is complete
	#if loop_progress_tracker > progress_ratio:
		#get_parent().spawn_duck()
	#loop_progress_tracker = progress_ratio

	
func process_duckling():
	pass
	
func process_juvenile():
	pass
	
func process_adult():
	pass
	
func physics_process_duckling(delta):
	loop_movement(delta)
	
func physics_process_juvenile(delta):
	loop_movement(delta)
	
func physics_process_adult(delta):
	loop_movement(delta)

func loop_movement(delta):
	progress_ratio += delta * speed

func _on_area_entered(_area: Area2D):
	match current_state:
		DuckState.DUCKLING:
			current_state = DuckState.JUVENILE
			duck_sprite.texture = duck_sprites[1]
		DuckState.JUVENILE:
			current_state = DuckState.ADULT
			duck_sprite.texture = duck_sprites[2]
		DuckState.ADULT:
			pass

func _on_quack_timer_timeout():
	quack_sfx.play()
	quack_timer.wait_time = randi_range(1, 4)
	match current_state:
		DuckState.DUCKLING:
			quack_sfx.pitch_scale = randf_range(1.15, 1.25)
		DuckState.JUVENILE:
			quack_sfx.pitch_scale = randf_range(0.9, 1.1)
		DuckState.ADULT:
			quack_sfx.pitch_scale = randf_range(0.65, 0.85)
	quack_timer.start()
	var new_quack_label: Node2D = quack_label_scene.instantiate()
	get_parent().add_child(new_quack_label)
	new_quack_label.global_position = global_position
