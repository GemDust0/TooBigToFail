extends Button

@onready var restockIcon: TextureRect = $"../RestockIcon"
@onready var background: Sprite2D = $"../Background"

func _ready() -> void:
	_on_mouse_exited()

func _on_button_down() -> void:
	restockIcon.self_modulate = get_theme_color("font_pressed_color")
	background.self_modulate = get_theme_color("font_pressed_color")


func _on_button_up() -> void:
	restockIcon.self_modulate = get_theme_color("font_hover_color")
	background.self_modulate = get_theme_color("font_hover_color")


func _on_mouse_entered() -> void:
	restockIcon.self_modulate = get_theme_color("font_hover_color")
	background.self_modulate = get_theme_color("font_hover_color")


func _on_mouse_exited() -> void:
	restockIcon.self_modulate = get_theme_color("font_color")
	background.self_modulate = get_theme_color("font_hover_color")
