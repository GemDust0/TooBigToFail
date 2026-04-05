class_name DescriptionLabel extends RichTextLabel

@export var max_size: int = 256

func show_description(new_text: String) -> void:
	text = new_text
	@warning_ignore("int_as_enum_without_cast")
	size.x = max_size
	size.x = get_content_width() + 7
	show()

func _process(_delta: float) -> void:
	if visible:
		global_position = get_global_mouse_position() + Vector2(2, 4)
		global_position = global_position.clamp(Vector2(4, 2), get_viewport_rect().size - size - Vector2(4, 2))
		
