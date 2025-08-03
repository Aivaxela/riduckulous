extends CharacterBody2D

@export var wine_sprite: Sprite2D
@export var wine_bomb_explosion: PackedScene

var target_position: Vector2
var start_position: Vector2
var travel_time: float = 1.0
var current_time: float = 0.0
var base_speed: float = 200.0
var rotation_speed: float = 720.0

func _ready():
	start_position = global_position
	var distance = start_position.distance_to(target_position)
	
	travel_time = distance / base_speed
	var horizontal_distance = target_position.x - start_position.x
	velocity.x = horizontal_distance / travel_time

func _process(delta):
	wine_sprite.rotation_degrees += rotation_speed * delta * velocity.normalized().x

func _physics_process(delta):
	current_time += delta
	
	var progress = current_time / travel_time
	if progress >= 1.0:
		var new_explosion = wine_bomb_explosion.instantiate()
		new_explosion.global_position = global_position
		get_tree().current_scene.add_child(new_explosion)
		queue_free()
		return
	
	var vertical_distance = target_position.y - start_position.y
	var distance = start_position.distance_to(target_position)
	var arc_height = distance * 0.3
	var new_y = start_position.y + (vertical_distance * progress) - (arc_height * sin(PI * progress))
	var new_x = start_position.x + (velocity.x * current_time)
		
	global_position = Vector2(new_x, new_y)
