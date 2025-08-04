extends Control

@onready var duck_count_label: Label = $VBoxContainer/DuckCountLabel

func _ready():
	var previous_scene = get_tree().current_scene
	var duck_count = 0
	
	if previous_scene.has_meta("ducks_in_pond"):
		duck_count = previous_scene.get_meta("ducks_in_pond")
	duck_count_label.text = str(duck_count) + " ducks happily made it to your pond!"

func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_exit_button_pressed():
	get_tree().quit() 
