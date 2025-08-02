extends CharacterBody2D

@export var boat_sprite: Sprite2D
@export var speed: float = 200.0
var acceleration: float = 4.0


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
	
