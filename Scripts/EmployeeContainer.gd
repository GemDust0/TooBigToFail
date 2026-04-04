class_name EmployeeContainer extends TextureRect

var employee: Employee = null:
	set(value):
		if employee == null:
			add_child(value)
		employee = value
		
@onready var highlight: ColorRect = $Highlight

func switch_employee(container: EmployeeContainer) -> void:
	employee.reparent(container)
	container.employee.reparent(self)
	var temp: Employee = container.employee
	var temp_grid_pos: Vector2i = employee.grid_pos
	container.employee = employee
	container.employee.grid_pos = temp.grid_pos
	temp.grid_pos = temp_grid_pos
	employee = temp
	employee.position = Vector2.ZERO
	container.employee.position = Vector2.ZERO
