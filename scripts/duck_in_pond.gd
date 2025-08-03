extends CharacterBody2D

@export var animated_sprite: AnimatedSprite2D

enum DuckState {IDLE, WANDERING}

@export var min_speed: float = 20.0
@export var max_speed: float = 60.0
@export var min_move_duration: float = 2.0
@export var max_move_duration: float = 6.0
@export var min_idle_duration: float = 1.0
@export var max_idle_duration: float = 4.0

var current_state: DuckState = DuckState.IDLE
var current_velocity: Vector2 = Vector2.ZERO
var move_timer: float = 0.0
var idle_timer: float = 0.0


func _ready():
	start_random_movement()

func _physics_process(delta):
	match current_state:
		DuckState.WANDERING:
			wandering(delta)
		DuckState.IDLE:
			idle(delta)

func wandering(delta):
	move_timer -= delta
	if move_timer <= 0:
		stop_moving()
		start_idle_period()
	else:
		velocity = current_velocity
		move_and_slide()

func idle(delta):
	idle_timer -= delta
	if idle_timer <= 0:
		start_random_movement()

func start_random_movement():
	var random_angle = randf() * TAU
	var direction = Vector2(cos(random_angle), sin(random_angle))
	var speed = randf_range(min_speed, max_speed)
	current_velocity = direction * speed
	move_timer = randf_range(min_move_duration, max_move_duration)
	if direction.x < 0: 
		animated_sprite.flip_h = false
	elif direction.x > 0:
		animated_sprite.flip_h = true
	current_state = DuckState.WANDERING

func stop_moving():
	current_velocity = Vector2.ZERO
	velocity = Vector2.ZERO
	current_state = DuckState.IDLE

func start_idle_period():
	idle_timer = randf_range(min_idle_duration, max_idle_duration)
	current_state = DuckState.IDLE
