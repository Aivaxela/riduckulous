extends Sprite2D

@export var path: PathFollow2D


func _process(_delta):
	flip_h = path.moving_right
