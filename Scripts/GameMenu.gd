class_name GameMenu extends Control

@onready var menu: ColorRect = $MenuNode/MenuGrayout
@onready var settings_highlight: ColorRect = %SettingsHighlight

func _ready() -> void:
	%SpinBox.value = AudioPlayer.volume_linear / AudioPlayer.max_volume * 100

func open() -> void:
	menu.visible = true

func close() -> void:
	menu.visible = false

func _on_spin_box_value_changed(value: float) -> void:
	AudioPlayer.volume_linear = AudioPlayer.max_volume * value / 100

func _on_save_exit_pressed() -> void:
	get_tree().quit()

func _on_settings_button_mouse_entered() -> void:
	settings_highlight.color = Color(1.0, 1.0, 1.0, 0.75)

func _on_settings_button_mouse_exited() -> void:
	settings_highlight.color = Color(0.0, 0.0, 0.0, 0.0)

func _on_settings_button_button_down() -> void:
	settings_highlight.color = Color(0.3, 0.3, 0.3, 0.75)

func _on_settings_button_pressed() -> void:
	settings_highlight.color = Color(0.0, 0.0, 0.0, 0.0)
