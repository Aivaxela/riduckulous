extends CharacterBody2D

enum FoxState {WANDERING, ATTACKING, FLEEING}
@export var duck_check_area: Area2D
@export var duck_touch_area: Area2D
@export var fox_sprite: Sprite2D
var goal: Node2D
var speed: float = 1000
var goal_reached_threshold: float = 10.0
var current_state: FoxState = FoxState.WANDERING
var target_area: Area2D = null
var previous_position: Vector2


func _ready():
	duck_check_area.area_entered.connect(_on_area_entered)
	duck_touch_area.area_entered.connect(_on_duck_touch_area_entered)

func _physics_process(delta):
	update_sprite_direction()
	
	match current_state:
		FoxState.WANDERING:
			wander(delta)
		FoxState.ATTACKING:
			attack(delta)
		FoxState.FLEEING:
			flee(delta)

func wander(delta):
	if goal and global_position.distance_to(goal.global_position) <= goal_reached_threshold:
		velocity = Vector2.ZERO
		return
	
	var direction = (goal.global_position - global_position).normalized()
	velocity = direction * speed * delta
	move_and_slide()

func attack(delta):
	if target_area:
		if target_area.get_parent().current_state != 0:
			current_state = FoxState.FLEEING
			return
		var direction = (target_area.global_position - global_position).normalized()
		velocity = direction * speed * 2 * delta
		move_and_slide()

func flee(delta):
	velocity = Vector2.LEFT * speed * 4 * delta
	move_and_slide()

func attack_duckling(area: Area2D):
	current_state = FoxState.ATTACKING
	target_area = area

func _on_area_entered(area: Area2D):
	var duck_state = area.get_parent().current_state
	if duck_state == 0:
		attack_duckling(area)

func _on_duck_touch_area_entered(area: Area2D):
	if (area.name == "duck_area" and area.get_parent().current_state == 0):
		if current_state != FoxState.FLEEING:
			area.get_parent().queue_free()
			current_state = FoxState.FLEEING
	if (area.name == "fox_escape_area"):
		get_parent().total_foxes -= 1
		queue_free()
		return

func update_sprite_direction():
	var movement_direction = global_position - previous_position
	if movement_direction.length() > 0.1:
		fox_sprite.flip_h = movement_direction.x > 0
	previous_position = global_position
