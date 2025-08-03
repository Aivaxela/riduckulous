extends Node2D

@export var fox_scene: PackedScene
@export var fox_spawns: Array[Node2D]
@export var fox_goals: Array[Node2D]
@export var fox_spawn_timer: Timer
@export var fox_spawn_timer_min: int
@export var fox_spawn_timer_max: int

var total_foxes: int = 0
var parent: Node2D

func _ready():
	fox_spawn_timer.timeout.connect(_on_fox_spawn_timer_timeout)
	fox_spawn_timer.wait_time = randi_range(fox_spawn_timer_min, fox_spawn_timer_max)
	fox_spawn_timer.start()

func _on_fox_spawn_timer_timeout():
	if total_foxes > 3:
		return

	var fox: CharacterBody2D = fox_scene.instantiate()
	fox.global_position = fox_spawns[randi_range(0, fox_spawns.size() - 1)].global_position
	fox.set_goal(fox_goals[randi_range(0, fox_goals.size() - 1)])
	add_child(fox)
	fox_spawn_timer.wait_time = randi_range(fox_spawn_timer_min, fox_spawn_timer_max)
	total_foxes += 1
	fox_spawn_timer.start()
