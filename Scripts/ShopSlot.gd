class_name ShopSlot extends Control

var too_expensive_col: String = Color(0.651, 0.067, 0.165, 1.0).to_html()

var employee: Employee
var cost: int
var locked: bool = false:
	set(value):
		if value:
			employeeIcon.texture = null
		locked = value

@onready var employeeIcon: TextureRect = $EmployeeIcon
@onready var cost_label: RichTextLabel = $Cost

func set_employee(new_employee: Employee, money: int=0) -> void:
	if new_employee != null:
		employeeIcon.texture = new_employee.get_icon()
		employeeIcon.self_modulate = new_employee.get_rarity_color()
		cost = get_cost(new_employee.rarity)
	else:
		employeeIcon.texture = null
	employee = new_employee
	update_description(money)

func update_description(money: int=0) -> void:
	if employee != null:
		cost_label.text = "[color=#%s]%s\n[color=#%s]Cost: %s[/color]" % [employee.get_rarity_color().to_html(), employee.id, too_expensive_col if money < cost else cost_label.get_theme_color("default_color").to_html(), cost]
	else:
		if locked:
			cost_label.text = "Locked"
		else:
			cost_label.text = "Empty"

static func get_cost(rarity: String) -> int:
	match rarity:
		"Common":
			return 200
		"Uncommon":
			return 1000
		"Rare":
			return 5000
		"Epic":
			return 20000
		"Legendary":
			return 50000
		_:
			return 50
