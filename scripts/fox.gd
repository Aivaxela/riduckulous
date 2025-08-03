extends CharacterBody2D

enum FoxState {WANDERING, ATTACKING, FLEEING, EXPLODING}
@export var duck_check_area: Area2D
@export var fox_touch_area: Area2D
@export var fox_sprite: Sprite2D
@export var animation_player: AnimationPlayer

var goal: Node2D
var varied_goal: Vector2
var speed: float = 700
var goal_reached_threshold: float = 10.0
var current_state: FoxState = FoxState.WANDERING
var target_area: Area2D = null
var previous_position: Vector2
var fox_sat: bool = false

func _ready():
	duck_check_area.area_entered.connect(_on_area_entered)
	fox_touch_area.area_entered.connect(_on_fox_touch_area_entered)
	animation_player.play("wander")
	if goal:
		set_goal(goal)

func _physics_process(delta):
	update_sprite_direction()
	
	match current_state:
		FoxState.WANDERING:
			wander(delta)
		FoxState.ATTACKING:
			attack(delta)
		FoxState.FLEEING:
			flee(delta)
		FoxState.EXPLODING:
			explode(delta)


func wander(delta):
	if goal and global_position.distance_to(varied_goal) <= goal_reached_threshold:
		velocity = Vector2.ZERO
		fox_sprite.texture = load("res://sprites/fox_idle.png")
		animation_player.stop()
		fox_sat = true
		return

	var direction = (varied_goal - global_position).normalized()
	velocity = direction * speed * delta
	move_and_slide()

func attack(delta):
	if fox_sat:
		fox_sprite.texture = load("res://sprites/fox.png")
		fox_sat = false
	if target_area:
		if target_area.get_parent().current_state != 0:
			current_state = FoxState.FLEEING
			animation_player.play("fleeing")
			return
		var direction = (target_area.global_position - global_position).normalized()
		velocity = direction * speed * 2 * delta
		move_and_slide()

func flee(delta):
	if fox_sat:
		fox_sprite.texture = load("res://sprites/fox.png")
		fox_sat = false
	velocity = Vector2.LEFT * speed * 4 * delta
	move_and_slide()

func explode(delta):
	if fox_sat:
		fox_sprite.texture = load("res://sprites/fox.png")
		fox_sat = false
	var random_speed_multiplier = randf_range(2, 5)
	velocity = Vector2.LEFT * speed * random_speed_multiplier * delta
	move_and_slide()

func set_goal(new_goal: Node2D):
	goal = new_goal
	if goal:
		var variation = Vector2(randf_range(-16, 16), randf_range(-16, 16))
		varied_goal = goal.global_position + variation

func attack_duckling(area: Area2D):
	current_state = FoxState.ATTACKING
	target_area = area

func _on_area_entered(area: Area2D):
	var duck_state = area.get_parent().current_state
	if duck_state == 0:
		attack_duckling(area)

func _on_fox_touch_area_entered(area: Area2D):
	if (area.name == "duck_area" and area.get_parent().current_state == 0):
		if current_state != FoxState.FLEEING and current_state != FoxState.EXPLODING:
			if area.get_parent().current_gender == 0:
				get_node("/root/main").drake_count -= 1
			elif area.get_parent().current_gender == 1:
				get_node("/root/main").hen_count -= 1
			area.get_parent().queue_free()
			current_state = FoxState.FLEEING
			animation_player.play("fleeing")
	if (area.name == "fox_escape_area"):
		get_parent().total_foxes -= 1
		queue_free()
		return
	if (area.name == "egg_bomb_explosion"):
		animation_player.play("death_anim")
		get_parent().total_foxes -= 1
		current_state = FoxState.EXPLODING
	if (area.name == "drake_scare_area"):
		current_state = FoxState.FLEEING
		animation_player.play("fleeing")

func update_sprite_direction():
	if current_state == FoxState.EXPLODING:
		return
	var movement_direction = global_position - previous_position
	if movement_direction.length() > 0.1:
		fox_sprite.flip_h = movement_direction.x > 0
	previous_position = global_position
