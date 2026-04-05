class_name DescriptionLabel extends RichTextLabel

@export var max_size: int = 256
var should_show: bool = false
var show_locked: bool = false:
	set(value):
		if show_locked == true:
			visible = should_show
		show_locked = value

func show_description(new_text: String, bypass: bool=false) -> void:
	text = new_text
	@warning_ignore("int_as_enum_without_cast")
	size.x = max_size
	size.x = get_content_width() + 7
	size.y = 1
	should_show = true
	if !show_locked || bypass:
		show()

func hide_description(bypass: bool=false) -> void:
	should_show = false
	if !show_locked || bypass:
		hide()

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position() + Vector2(2, 4)
	global_position = global_position.clamp(Vector2(4, 2), get_viewport_rect().size - size - Vector2(4, 2))
