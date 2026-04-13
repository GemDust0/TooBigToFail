class_name GameMenu extends Control

signal closed

@onready var menu: CanvasLayer = $MenuLayer
@onready var settings_highlight: ColorRect = %SettingsHighlight
static var is_open: bool = false
static var icon_hovered: bool = false

func _ready() -> void:
	ButtonPress.bind_button($IconContainer/ColorRect/MarginContainer/MarginContainer/SettingsIcon/SettingsButton)
	ButtonPress.bind_button($MenuLayer/MenuGrayout/MenuContainer/MarginContainer/MarginContainer/VBoxContainer/MarginContainer2/MarginContainer/MarginContainer/Return)
	ButtonPress.bind_button($MenuLayer/MenuGrayout/MenuContainer/MarginContainer/MarginContainer/VBoxContainer/MarginContainer/MarginContainer/MarginContainer/SaveExit)

func _input(event: InputEvent) -> void:
	if !TransitionObject.fading && event.is_action_pressed("esc"):
		if is_open:
			close()
		else:
			open()

func open() -> void:
	%MusicVolumeSpinBox.value = AudioPlayer.volume_linear / AudioPlayer.max_volume * 100
	%SFXVolumeSpinBox.value = db_to_linear(AudioPlayer.cur_sfx_volume) / AudioPlayer.max_sfx_volume * 100
	_on_settings_button_pressed()
	menu.visible = true
	get_tree().paused = true
	is_open = true

func close() -> void:
	menu.visible = false
	get_tree().paused = false
	is_open = false
	closed.emit()

func _on_music_volume_changed(value: float) -> void:
	ButtonPress.play_sound(0.1, 1.1, 0.07)
	AudioPlayer.volume_linear = AudioPlayer.max_volume * value / 100

func _on_sfx_volume_changed(value: float) -> void:
	ButtonPress.play_sound(0.1, 1.1, 0.07)
	AudioPlayer.cur_sfx_volume = linear_to_db(AudioPlayer.max_sfx_volume * value / 100)
	
func _on_save_exit_pressed() -> void:
	SaveManager.save()
	get_tree().call_deferred("quit")

func _on_settings_button_mouse_entered() -> void:
	settings_highlight.color = Color(1.0, 1.0, 1.0, 0.75)
	icon_hovered = true

func _on_settings_button_mouse_exited() -> void:
	settings_highlight.color = Color(0.0, 0.0, 0.0, 0.0)
	icon_hovered = false

func _on_settings_button_button_down() -> void:
	settings_highlight.color = Color(0.3, 0.3, 0.3, 0.75)
	icon_hovered = true

func _on_settings_button_pressed() -> void:
	settings_highlight.color = Color(0.0, 0.0, 0.0, 0.0)
	icon_hovered = false
