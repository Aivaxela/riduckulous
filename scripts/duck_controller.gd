extends PathFollow2D

enum DuckState {DUCKLING, JUVENILE, ADULT}
enum DuckGender {DRAKE, HEN}

@export var speed = 0.05
@export var quack_sfx: AudioStreamPlayer
@export var quack_timer: Timer
@export var quack_label_scene: PackedScene
@export var duck_sprite: Sprite2D
@export var genderkerchief: Sprite2D
@export var duck_sprites: Array[CompressedTexture2D]
@export var duck_area: Area2D
@export var quack_timer_min: float = 1
@export var quack_timer_max: float = 5

var parent: Path2D
var loop_progress_tracker: float = 0.00
var current_state: DuckState = DuckState.DUCKLING
var current_gender: DuckGender = DuckGender.DRAKE
var previous_position: Vector2
var date_completed: bool = false

func _ready():
	parent = get_parent()
	quack_timer.timeout.connect(_on_quack_timer_timeout)
	duck_area.area_entered.connect(_on_area_entered)
	quack_timer.wait_time = randf_range(quack_timer_min, quack_timer_max)
	quack_timer.start()
	quack_sfx.pitch_scale = randf_range(0.9, 1.5)
	duck_sprite.texture = duck_sprites[0]

func _process(_delta):
	rotation = 0
	update_sprite_direction()
	
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

func update_sprite_direction():
	var movement_direction = global_position - previous_position
	if movement_direction.length() > 0.1:
		duck_sprite.flip_h = movement_direction.x > 0
		genderkerchief.flip_h = movement_direction.x > 0
	previous_position = global_position

func update_duck_state():
	match current_state:
		DuckState.DUCKLING:
			current_state = DuckState.JUVENILE
			genderkerchief.visible = true
			duck_sprite.texture = duck_sprites[1]
		DuckState.JUVENILE:
			current_state = DuckState.ADULT
			genderkerchief.scale = Vector2(1.0, 1.0)
			duck_sprite.texture = duck_sprites[2]
		DuckState.ADULT:
			pass

func _on_area_entered(area: Area2D):
	if area.name == "duck_capture_area" and !date_completed:
		if current_gender == DuckGender.DRAKE and !area.get_parent().drake_spot_taken:
			area.get_parent().drake_spot_taken = true
			queue_free()
		elif current_gender == DuckGender.HEN and !area.get_parent().hen_spot_taken:
			area.get_parent().hen_spot_taken = true
			queue_free()
		return
	elif area.name == "duckling_juvie_gate" or area.name == "juvie_adult_gate":
		update_duck_state()

func _on_quack_timer_timeout():
	quack_sfx.play()
	quack_timer.wait_time = randf_range(quack_timer_min, quack_timer_max)
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
	get_parent().spawn_duck()
