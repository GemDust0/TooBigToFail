class_name EmployeeContainer extends TextureRect

var employee: Employee = null
		
@onready var highlight: ColorRect = $Highlight

func add_employee(new_employee: Employee) -> void:
	employee = new_employee
	add_child(employee)

func switch_employee(container: EmployeeContainer, grid_pos: Vector2) -> void:
	if employee == null:
		return
	employee.reparent(container)
	if container.employee != null:
		container.employee.reparent(self)
		var temp: Employee = container.employee
		var temp_grid_pos: Vector2i = employee.grid_pos
		container.employee = employee
		container.employee.grid_pos = temp.grid_pos
		temp.grid_pos = temp_grid_pos
		employee = temp
		employee.position = Vector2.ZERO
	else:
		container.employee = employee
		container.employee.grid_pos = grid_pos
		employee = null
	container.employee.position = Vector2.ZERO
