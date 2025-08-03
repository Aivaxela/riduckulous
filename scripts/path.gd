extends Path2D

@export var duck: PackedScene
@export var duck_speed_min: float = 0.02
@export var duck_speed_max: float = 0.05
var count: int = 0

func spawn_duck(gender: String = "", progress_ratio: float = 0.00, speed: float = 0.00):
	var new_duck: PathFollow2D = duck.instantiate()
	add_child(new_duck)
	new_duck.speed = speed if speed != 0.00 else randf_range(duck_speed_min, duck_speed_max)
	new_duck.progress_ratio = progress_ratio
	assign_gender(new_duck, gender)

func assign_gender(new_duck: PathFollow2D, gender: String = ""):
	if gender == "drake":
		new_duck.add_to_group("drake")
		new_duck.genderkerchief.modulate = Color(0.5, 0.75, 1.2, 1.0)
		new_duck.current_gender = 0 
		new_duck.update_duck_state()
		new_duck.date_completed = true
	elif gender == "hen":
		new_duck.add_to_group("hen")
		new_duck.genderkerchief.modulate = Color(1.1, 0.6, 1.0, 1.0)
		new_duck.current_gender = 1
		new_duck.update_duck_state()
		new_duck.date_completed = true
	else:
		var group = get_node("/root/main").decide_duck_gender()
		new_duck.add_to_group(group)
		if (group == "drake"):
			new_duck.genderkerchief.modulate = Color(0.5, 0.75, 1.2, 1.0)
			new_duck.current_gender = 0
			get_node("/root/main").drake_count += 1
		elif (group == "hen"):
			new_duck.genderkerchief.modulate = Color(1.1, 0.6, 1.0, 1.0)
			new_duck.current_gender = 1
			get_node("/root/main").hen_count += 1
