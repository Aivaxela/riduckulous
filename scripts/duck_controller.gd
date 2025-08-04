extends PathFollow2D

enum DuckState {DUCKLING, JUVENILE, ADULT}
enum DuckGender {DRAKE, HEN}

@export var speed = 0.05
@export var quack_sfx: AudioStreamPlayer
@export var quack_timer: Timer
@export var quack_label_scene: PackedScene
@export var duck_sprite: Sprite2D
@export var angry_drake_sprite: AnimatedSprite2D
@export var genderkerchief: Sprite2D
@export var duck_sprites: Array[CompressedTexture2D]
@export var duck_area: Area2D
@export var quack_timer_min: float = 1
@export var quack_timer_max: float = 5
@export var current_gender: DuckGender = DuckGender.HEN
@export var animation_player: AnimationPlayer
@export var drake_scare_area: Area2D

var parent: Path2D
var loop_progress_tracker: float = 0.00
var current_state: DuckState = DuckState.DUCKLING
var previous_position: Vector2
var date_completed: bool = false
var angry_loop_started: bool = false

func _ready():
	parent = get_parent()
	quack_timer.timeout.connect(_on_quack_timer_timeout)
	duck_area.area_entered.connect(_on_area_entered)
	quack_timer.wait_time = randf_range(quack_timer_min, quack_timer_max)
	quack_timer.start()
	quack_sfx.pitch_scale = randf_range(0.9, 1.5)
	duck_sprite.texture = duck_sprites[0]
	animation_player.play("duckling")

func _process(_delta):
	rotation = 0
	update_sprite_direction()
			
func _physics_process(delta):
	loop_movement(delta)
	
func loop_movement(delta):
	progress_ratio += delta * speed

func update_sprite_direction():
	var movement_direction = global_position - previous_position
	if movement_direction.length() > 0.1:
		duck_sprite.flip_h = movement_direction.x > 0
		angry_drake_sprite.flip_h = movement_direction.x > 0
		genderkerchief.flip_h = movement_direction.x > 0
	previous_position = global_position

func update_duck_state(area_name: String):
	match current_state:
		DuckState.DUCKLING:
			current_state = DuckState.JUVENILE
			genderkerchief.visible = true
			duck_sprite.texture = duck_sprites[1]
			animation_player.play("juvie")
		DuckState.JUVENILE:
			current_state = DuckState.ADULT
			genderkerchief.scale = Vector2(1.0, 1.0)
			duck_sprite.texture = duck_sprites[2]
			animation_player.play("adult")
		DuckState.ADULT:
			if current_gender == DuckGender.DRAKE:
				if angry_loop_started and area_name == "adult_egg_gate":
					remove_from_group("drake")
					get_node("/root/main").add_duck_to_pond("drake")
					queue_free()
					return
				speed = 0.08
				angry_drake_sprite.visible = true
				duck_sprite.visible = false
				genderkerchief.visible = false
				angry_loop_started = true
				drake_scare_area.set_deferred("monitorable", true)
			elif current_gender == DuckGender.HEN:func spawn_duck_on_random_path():
	var paths = get_tree().get_nodes_in_group("path")
	if paths.size() > 0:
		var random_path = paths[randi_range(0, paths.size() - 1)]
		random_path.spawn_duck()
		queue_free()

func reset_cursor():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	modulate = Color(1.0, 1.0, 1.0, 1.0)
				remove_from_group("hen")
				get_node("/root/main").spawn_egg(randi_range(1, 4))
				get_node("/root/main").add_duck_to_pond("hen")
				queue_free()
			
func _on_area_entered(area: Area2D):
	if area.name == "duck_capture_area" and !date_completed:
		if current_gender == DuckGender.DRAKE and !area.get_parent().drake_spot_taken:
			area.get_parent().drake_spot_taken = true
			queue_free()
		elif current_gender == DuckGender.HEN and !area.get_parent().hen_spot_taken:
			area.get_parent().hen_spot_taken = true
			queue_free()
		return
	elif area.name == "duckling_juvie_gate" or area.name == "juvie_adult_gate" or area.name == "adult_egg_gate":
		update_duck_state(area.name)

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
