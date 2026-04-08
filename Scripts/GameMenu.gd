class_name GameMenu extends Control

@onready var menu: MarginContainer = $MenuContainer

func _ready() -> void:
	$MenuContainer/MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/SpinBox.value = AudioPlayer.volume_linear / AudioPlayer.max_volume * 100

func open() -> void:
	menu.visible = true

func close() -> void:
	menu.visible = false

func _on_spin_box_value_changed(value: float) -> void:
	AudioPlayer.volume_linear = AudioPlayer.max_volume * value / 100

func _on_save_exit_pressed() -> void:
	get_tree().quit()
