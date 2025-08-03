extends Node2D

@export var egg_area: Area2D

func _ready():
	egg_area.input_event.connect(_on_area_input_event)
	egg_area.mouse_entered.connect(_on_mouse_entered)
	egg_area.mouse_exited.connect(_on_mouse_exited)

func _on_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			reset_cursor()
			spawn_duck_on_random_path()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			reset_cursor()
			print("egg taken")
			get_node("/root/main/boat").egg_count += 1
			queue_free()

func _on_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	modulate = Color(1.2, 1.2, 0.8, 1.0)

func _on_mouse_exited():
	reset_cursor()

func spawn_duck_on_random_path():
	var paths = get_tree().get_nodes_in_group("path")
	if paths.size() > 0:
		var random_path = paths[randi_range(0, paths.size() - 1)]
		random_path.spawn_duck()
		queue_free()

func reset_cursor():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	modulate = Color(1.0, 1.0, 1.0, 1.0)
