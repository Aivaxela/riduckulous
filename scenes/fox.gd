extends CharacterBody2D

enum FoxState {WANDERING, ATTACKING}

var goal: Node2D
var speed: float = 1000
var goal_reached_threshold: float = 10.0
@export var duck_check_area: Area2D

var current_state: FoxState = FoxState.WANDERING
var target_area: Area2D = null


func _ready():
	duck_check_area.area_entered.connect(_on_area_entered)

func _physics_process(delta):
	match current_state:
		FoxState.WANDERING:
			wander(delta)
		FoxState.ATTACKING:
			attack(delta)

func wander(delta):
	if goal and global_position.distance_to(goal.global_position) <= goal_reached_threshold:
		velocity = Vector2.ZERO
		return
	
	var direction = (goal.global_position - global_position).normalized()
	velocity = direction * speed * delta
	move_and_slide()

func attack(delta):
	if target_area:
		var direction = (target_area.global_position - global_position).normalized()
		velocity = direction * speed * 2 * delta
		move_and_slide()

func attack_duckling(area: Area2D):
	print("attacking duckling")
	current_state = FoxState.ATTACKING
	target_area = area

func _on_area_entered(area: Area2D):
	var duck_state = area.get_parent().current_state
	if duck_state == 0:
		attack_duckling(area)
