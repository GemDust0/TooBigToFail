class_name EmployeeContainer extends TextureRect

var employee: Employee = null

func change_employee(new_employee: Employee) -> void:
	if employee != null:
		remove_child(get_child(0))
	employee = new_employee
	add_child(employee)
