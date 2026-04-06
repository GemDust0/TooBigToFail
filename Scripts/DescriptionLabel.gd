class_name DescriptionLabel extends RichTextLabel

@export var max_size: int = 256
var should_show: bool = false
var show_locked: Node = null:
	set(value):
		if value == null:
			visible = should_show
		show_locked = value

func show_description(new_text: String, caller: Node) -> void:
	text = new_text
	@warning_ignore("int_as_enum_without_cast")
	size.x = max_size
	size.x = get_content_width() + 7
	size.y = 1
	should_show = true
	if show_locked == null || caller == show_locked:
		show()

func hide_description(caller: Node) -> void:
	should_show = false
	if show_locked == null || caller == show_locked:
		hide()

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position() + Vector2(2, 4)
	global_position = global_position.clamp(Vector2(4, 2), get_viewport_rect().size - size - Vector2(4, 2))

func change_show_locked(value: bool, caller: Node) -> void:
	if show_locked == null || caller == show_locked:
		show_locked = caller if value else null
