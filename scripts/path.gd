extends Path2D

@export var sprite_flip_thresholds: Array[float] = [0.00,0.00]
@export var duck: PackedScene

func spawn_duck():
	var new_duck = duck.instantiate()
	add_child(new_duck)
	var new_duck_speed = randf_range(0.06, 0.18)
	new_duck.speed = new_duck_speed
	print("spawning duck with speed of %.2f" % new_duck_speed)
