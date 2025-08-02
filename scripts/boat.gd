extends CharacterBody2D

@export var boat_sprite: Sprite2D
@export var egg_bomb: PackedScene
@export var speed: float = 150.0
var acceleration: float = 3.0


func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	input_vector.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	if input_vector.length() > 0:
		input_vector = input_vector.normalized()
	
	if input_vector.x != 0:
		boat_sprite.flip_h = input_vector.x > 0
	
	velocity = velocity.lerp(input_vector * speed, acceleration * delta)
	move_and_slide()

func _input(event):
	if event.is_action_pressed("fire_egg"):
		fire_egg()

func fire_egg():
	if get_node("/root/main").egg_count > 0:
		get_node("/root/main").egg_count -= 1
		var new_egg_bomb = egg_bomb.instantiate()
		new_egg_bomb.global_position = global_position
		new_egg_bomb.target_position = get_global_mouse_position()
		get_tree().current_scene.add_child(new_egg_bomb)
	
