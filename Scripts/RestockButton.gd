extends Button

@onready var restockIcon: TextureRect = %RestockIcon
var undisabled_modulate: Color

func _ready() -> void:
	_on_mouse_exited()

func _on_button_down() -> void:
	undisabled_modulate = get_theme_color("font_pressed_color")
	if !disabled:
		restockIcon.self_modulate = undisabled_modulate

func _on_button_up() -> void:
	undisabled_modulate = get_theme_color("font_hover_color")
	if !disabled:
		restockIcon.self_modulate = undisabled_modulate

func _on_mouse_entered() -> void:
	undisabled_modulate = get_theme_color("font_hover_color")
	if !disabled:
		restockIcon.self_modulate = undisabled_modulate

func _on_mouse_exited() -> void:
	undisabled_modulate = get_theme_color("font_color")
	if !disabled:
		restockIcon.self_modulate = undisabled_modulate

func disable() -> void:
	restockIcon.self_modulate = get_theme_color("font_disabled_color")
	disabled = true

func undisable() -> void:
	restockIcon.self_modulate = undisabled_modulate
	disabled = false
