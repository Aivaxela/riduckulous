extends PathFollow2D

@export var moving_right: bool = false
@export var speed = 0.05
@export var quack_sfx: AudioStreamPlayer
@export var quack_timer: Timer
@export var quack_label_scene: PackedScene

var parent: Path2D
var loop_progress_tracker: float = 0.00


func _ready():
	parent = get_parent()
	quack_timer.timeout.connect(_on_quack_timer_timeout)
	quack_timer.wait_time = randf_range(1, 4)
	quack_timer.start()
	quack_sfx.pitch_scale = randf_range(0.9, 1.5)

func _process(_delta):
	rotation = 0
	moving_right = progress_ratio > parent.sprite_flip_thresholds[0] && progress_ratio < parent.sprite_flip_thresholds[1]
	if loop_progress_tracker > progress_ratio:
		get_parent().spawn_duck()
		
	loop_progress_tracker = progress_ratio

func _physics_process(delta):
	loop_movement(delta)

func loop_movement(delta):
	progress_ratio += delta * speed
	
func _on_quack_timer_timeout():
	quack_sfx.play()
	quack_timer.wait_time = randf_range(1, 4)
	quack_sfx.pitch_scale = randf_range(0.85, 1.15)
	quack_timer.start()
	var new_quack_label: Node2D = quack_label_scene.instantiate()
	get_parent().add_child(new_quack_label)
	new_quack_label.global_position = global_position
