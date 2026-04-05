class_name EmployeeDescription extends RichTextLabel


func show_description(employee: Employee) -> void:
	text = employee.description
	@warning_ignore("int_as_enum_without_cast")
	size = get_theme_font("normal_font").get_multiline_string_size(get_parsed_text(), 0, -1, 11)
	show()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && visible:
		global_position = get_global_mouse_position() + Vector2(2, 4)
