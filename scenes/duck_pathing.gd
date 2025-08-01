extends PathFollow2D

@export var moving_right: bool = false
@export var speed = 0.05

var parent: Path2D

func _ready():
	parent = get_parent()

func _process(_delta):
	rotation = 0
	moving_right = progress_ratio > parent.sprite_flip_thresholds[0] && progress_ratio < parent.sprite_flip_thresholds[1]

func _physics_process(delta):
	loop_movement(delta)

func loop_movement(delta):
	progress_ratio += delta * speed
