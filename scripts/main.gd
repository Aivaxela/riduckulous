extends Node

@export var volume_slider: HSlider

var drake_count: int = 0
var hen_count: int = 0

func _ready():
	volume_slider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	volume_slider.value_changed.connect(_on_vol_slider_value_changed)

func _process(_delta):
	drake_count = get_tree().get_nodes_in_group("drake").size()
	hen_count = get_tree().get_nodes_in_group("hen").size()

func decide_duck_gender() -> String:
	var total = drake_count + hen_count
	
	if total == 0:
		return "drake" if randf() < 0.5 else "hen"
	
	var drake_ratio = float(drake_count) / total
	var hen_ratio = float(hen_count) / total
	
	var drake_weight = hen_ratio * hen_ratio 
	var hen_weight = drake_ratio * drake_ratio
	
	var total_weight = drake_weight + hen_weight
	drake_weight /= total_weight
	hen_weight /= total_weight
	
	var random_value = randf()
	if random_value < drake_weight:
		return "drake"
	else:
		return "hen"

func _on_vol_slider_value_changed(_value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume_slider.value)
