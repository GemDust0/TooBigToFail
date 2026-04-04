class_name EmployeeContainer extends TextureRect

var employee: Employee = null:
	set(value):
		if employee != null:
			remove_child(get_child(0))
		employee = value
		add_child(employee)
