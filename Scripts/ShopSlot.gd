extends Control

var employee: Employee

@onready var employeeIcon: TextureRect = $EmployeeIcon
@onready var cost: RichTextLabel = $Cost

func set_employee(new_employee: Employee) -> void:
	if new_employee != null:
		employeeIcon.texture = new_employee.get_icon()
		employeeIcon.self_modulate = new_employee.get_rarity_color()
		cost.text = "[color=#%s]%s[/color]\nCost: 50" % [new_employee.get_rarity_color().to_html(), new_employee.id]
	employee = new_employee
