class_name ShopSlot extends Control

var too_expensive_col: String = Color(0.65, 0.065, 0.163, 1.0).to_html()

var employee: Employee
var cost: int

@onready var employeeIcon: TextureRect = $EmployeeIcon
@onready var cost_label: RichTextLabel = $Cost

func set_employee(new_employee: Employee, money: int=0) -> void:
	if new_employee != null:
		employeeIcon.texture = new_employee.get_icon()
		employeeIcon.self_modulate = new_employee.get_rarity_color()
		cost = 50
		cost_label.text = "[color=#%s]%s\n[color=#%s]Cost: %s[/color]" % [new_employee.get_rarity_color().to_html(), new_employee.id, too_expensive_col if money < cost else cost_label.get_theme_color("default_color").to_html(), cost]
	employee = new_employee

func update_description(money: int=0) -> void:
	cost_label.text = "[color=#%s]%s\n[color=#%s]Cost: %s[/color]" % [employee.get_rarity_color().to_html(), employee.id, too_expensive_col if money < cost else cost_label.get_theme_color("default_color").to_html(), cost]
