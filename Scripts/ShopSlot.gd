extends Control

@onready var description: RichTextLabel = $Description

func set_employee(new_employee: Employee) -> void:
	description.clear()
	if new_employee != null:
		add_child(new_employee)
		description.append_text(new_employee.description)
