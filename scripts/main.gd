extends Node

@export var volume_slider: HSlider

func _ready():
	volume_slider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	volume_slider.value_changed.connect(_on_vol_slider_value_changed)
	
func _on_vol_slider_value_changed(_value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume_slider.value)
