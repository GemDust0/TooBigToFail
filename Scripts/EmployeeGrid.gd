class_name EmployeeGrid extends GridContainer

@export var employeeContainerScene: PackedScene
var grid: Dictionary[Vector2i, EmployeeContainer]

func create_grid(grid_size: int) -> void:
	columns = grid_size
	for row: int in range(grid_size):
		for col: int in range(grid_size):
			var container: EmployeeContainer = create_container()
			@warning_ignore("integer_division")
			container.employee.grid_pos = Vector2i(row, col)
			grid[Vector2i(row, col)] = container
			add_child(container)

func increase_grid_size(amount: int) -> void:
	for row: int in range(amount):
		for col: int in range(amount + columns):
			var container: EmployeeContainer = create_container()
			grid[Vector2i(row + columns, col)] = container
			container.employee.grid_pos = Vector2i(row + columns, col)
			add_child(container)
	for row: int in range(columns-1, -1, -1):
		for col: int in range(amount):
			var container: EmployeeContainer = create_container()
			grid[Vector2i(row, col + columns)] = container
			container.employee.grid_pos = Vector2i(row, col + columns)
			insert_child(container, row*columns+(columns-col))
	columns += amount

func decrease_grid_size(amount: int) -> void:
	for key: Vector2i in grid.keys():
		if key.x >= (columns-amount) || key.y >= (columns-amount):
			grid[key].queue_free()
			grid.erase(key)
	columns -= amount

func insert_child(child: Node, index: int) -> void:
	add_child(child)
	move_child(child, index)

func create_container() -> EmployeeContainer:
	var container: EmployeeContainer = employeeContainerScene.instantiate()
	container.employee = load("res://Scenes/Employees/InternDeveloper.tscn").instantiate()
	container.employee.modulate = Color(randf(), randf(), randf())
	return container
