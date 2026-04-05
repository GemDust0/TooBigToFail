class_name EmployeeGrid extends GridContainer

signal money_produced(amount: int)

@export var employeeContainerScene: PackedScene
var grid: Dictionary[Vector2i, EmployeeContainer]
var held: Employee = null
var highlighted_container: Vector2i = Vector2(-1, -1)

func create_grid(grid_size: int) -> void:
	columns = grid_size
	for row: int in range(grid_size):
		for col: int in range(grid_size):
			var container: EmployeeContainer = create_container()
			#@warning_ignore("integer_division")
			#container.employee.grid_pos = Vector2i(row, col)
			grid[Vector2i(row, col)] = container
			add_child(container)

func increase_grid_size(amount: int) -> void:
	for row: int in range(amount):
		for col: int in range(amount + columns):
			var container: EmployeeContainer = create_container()
			grid[Vector2i(row + columns, col)] = container
			#container.employee.grid_pos = Vector2i(row + columns, col)
			add_child(container)
	for row: int in range(columns-1, -1, -1):
		for col: int in range(amount):
			var container: EmployeeContainer = create_container()
			grid[Vector2i(row, col + columns)] = container
			#container.employee.grid_pos = Vector2i(row, col + columns)
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
	#container.employee = load("res://Scenes/Employees/InternDeveloper.tscn").instantiate()
	#container.employee.self_modulate = Color(randf(), randf(), randf())
	#container.employee.produced.connect(employee_production)
	return container

func get_cursor_grid_pos() -> Vector2i:
	var mouse_pos: Vector2 = get_local_mouse_position()
	if mouse_pos.x < 0 || mouse_pos.y < 0:
		return Vector2i(-1, -1)
	var cursor_grid_pos: Vector2i = mouse_pos/32
	if cursor_grid_pos.x >= columns || cursor_grid_pos.y >= columns:
		return Vector2i(-1, -1)
	return Vector2i(cursor_grid_pos.y, cursor_grid_pos.x)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_click"):
			var cursor_grid_pos: Vector2i = get_cursor_grid_pos()
			if cursor_grid_pos != Vector2i(-1, -1):
				held = grid[cursor_grid_pos].employee
				held.z_index += 1
		elif event.is_action_released("left_click") && held != null:
			var cursor_grid_pos: Vector2i = get_cursor_grid_pos()
			if cursor_grid_pos != Vector2i(-1, -1):
				grid[held.grid_pos].switch_employee(grid[cursor_grid_pos])
			else:
				held.position = Vector2.ZERO
			held.z_index -= 1
			held = null
	if event is InputEventMouseMotion:
		if held != null:
			held.position += event.relative
		var cursor_grid_pos: Vector2i = get_cursor_grid_pos()
		if cursor_grid_pos != highlighted_container:
			if highlighted_container != Vector2i(-1, -1):
				grid[highlighted_container].highlight.hide()
			if cursor_grid_pos != Vector2i(-1, -1):
				grid[cursor_grid_pos].highlight.show()
			highlighted_container = cursor_grid_pos

func employee_production(employee: Employee) -> void:
	var production_worth: int = employee.production_value
	money_produced.emit(production_worth)
	employee.create_production_text(production_worth)
