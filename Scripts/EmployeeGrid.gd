class_name EmployeeGrid extends GridContainer

@export var employeeContainerScene: PackedScene

func create_grid(grid_size: int) -> void:
	columns = grid_size
	for i: int in range(grid_size * grid_size):
		var container: EmployeeContainer = employeeContainerScene.instantiate()
		container.change_employee(load("res://Scenes/Employees/InternDeveloper.tscn").instantiate())
		add_child(container)

func increase_grid_size(amount: int) -> void:
	for row: int in range(amount):
		for col: int in range(amount + columns):
			var container: EmployeeContainer = employeeContainerScene.instantiate()
			container.change_employee(load("res://Scenes/Employees/InternDeveloper.tscn").instantiate())
			add_child(container)
	for row: int in range(columns-1, -1, -1):
		for col: int in range(amount):
			var container: EmployeeContainer = employeeContainerScene.instantiate()
			container.change_employee(load("res://Scenes/Employees/InternDeveloper.tscn").instantiate())
			insert_child(container, row*columns+(columns-col))
	columns += amount

func decrease_grid_size(amount: int) -> void:
	var grid: Array[Node] = get_children()
	for row: int in range(columns):
		for col: int in range(amount):
			grid[row*columns+(columns - col - 1)].queue_free()
	for i: int in range((columns - amount) * columns, columns*columns):
		grid[i].queue_free()
	columns -= amount

func insert_child(child: Node, index: int) -> void:
	add_child(child)
	move_child(child, index)
