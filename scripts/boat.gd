extends CharacterBody2D

enum Selection {
	EGG,
	FINE_WINE,
	BREAD
}

@export var boat_sprite: AnimatedSprite2D
@export var egg_bomb: PackedScene
@export var speed: float = 150.0
@export var collect_area: Area2D
@export var selection_marker: Sprite2D

var acceleration: float = 3.0
var egg_count: int = 10
var fine_wine_count: int = 0
var bread_count: int = 0	
var selection: Selection = Selection.EGG

func _ready():
	collect_area.area_entered.connect(_on_area_entered)

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
	if event.is_action_pressed("select_egg"):
		selection = Selection.EGG
		selection_marker.global_position = get_node("/root/main/ui/egg_marker").global_position
	elif event.is_action_pressed("select_wine"):
		selection = Selection.FINE_WINE
		selection_marker.global_position = get_node("/root/main/ui/wine_marker").global_position
	elif event.is_action_pressed("select_bread"):
		selection = Selection.BREAD
		selection_marker.global_position = get_node("/root/main/ui/bread_marker").global_position

func fire_egg():
	if egg_count > 0:
		egg_count -= 1
		var new_egg_bomb = egg_bomb.instantiate()
		new_egg_bomb.global_position = global_position
		new_egg_bomb.target_position = get_global_mouse_position()
		get_tree().current_scene.add_child(new_egg_bomb)

func _on_area_entered(area: Area2D):
	if area.name == "fine_wine_collection_area":
		fine_wine_count += 1
	if area.name == "bread_collection_area":
		bread_count += 1
