class_name EmployeeGrid extends GridContainer

signal money_produced(amount: int)

@export var employeeContainerScene: PackedScene
var grid: Dictionary[Vector2i, EmployeeContainer]
var held: Employee = null
var highlighted_container: Vector2i = Vector2i(-1, -1)
var highlight_filled: bool = true:
	set(value):
		if highlighted_container != Vector2i(-1, -1) && (grid[highlighted_container].employee != null) == value:
			grid[highlighted_container].highlight.visible = !grid[highlighted_container].visible
		highlight_filled = value
var hovering_sell: bool = false
var paint_locked: bool = false
var disabled: bool = false
var negatives_earned: int = 0
var last_change: int = Time.get_ticks_msec()

@onready var description: DescriptionLabel = %DescriptionLabel
@onready var sell_area: TextureRect = %SellArea
@onready var sell_text: Label = %SellText

func _process(_delta: float) -> void:
	if (Time.get_ticks_msec() - last_change) >= 30000 && (!CorporateSim.instance.relic_inventory.has_relic("Employee Stability")): # 30000ms = 0.5min
		CorporateSim.instance.give_relic(load("res://Scenes/Relics/Stability.tscn").instantiate())

func create_grid(grid_size: int) -> void:
	columns = grid_size
	for row: int in range(grid_size):
		for col: int in range(grid_size):
			var container: EmployeeContainer = create_container()
			grid[Vector2i(row, col)] = container
			add_child(container)

func increase_grid_size(amount: int) -> void:
	for row: int in range(amount):
		for col: int in range(amount + columns):
			var container: EmployeeContainer = create_container()
			grid[Vector2i(row + columns, col)] = container
			add_child(container)
	for row: int in range(columns-1, -1, -1):
		for col: int in range(amount):
			var container: EmployeeContainer = create_container()
			grid[Vector2i(row, col + columns)] = container
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
	return container

func add_employee(pos: Vector2i, employee: Employee) -> void:
	last_change = Time.get_ticks_msec()
	grid[pos].add_employee(employee)
	if get_employee_count("Snitch") > 5 && !CorporateSim.instance.relic_inventory.has_relic("Snitches get... Snitches??"):
		CorporateSim.instance.give_relic(load("res://Scenes/Relics/SnitchesSnitches.tscn").instantiate())
	if get_employee_count("Rat") > 5 && !CorporateSim.instance.relic_inventory.has_relic("Mutualism"):
		CorporateSim.instance.give_relic(load("res://Scenes/Relics/Mutualism.tscn").instantiate())
	if get_employee_count("Project Manager") > 2 && !CorporateSim.instance.relic_inventory.has_relic("Management Overhaul"):
		CorporateSim.instance.give_relic(load("res://Scenes/Relics/ManagementOverhaul.tscn").instantiate())
	if get_employee_count("Amateur Developer") > 5 && !CorporateSim.instance.relic_inventory.has_relic("Amateur Hour"):
		CorporateSim.instance.give_relic(load("res://Scenes/Relics/AmateurHour.tscn").instantiate())
	if !CorporateSim.instance.relic_inventory.has_relic("Cats And Dogs") && has_employee("Cat") && has_employee("Dog"):
		CorporateSim.instance.give_relic(load("res://Scenes/Relics/CatsAndDogs.tscn").instantiate())
	check_grid_for_relics()
	employee.produced.connect(employee_production)
	employee.grid_pos = pos
	var speed_mult: float = 1.0
	var synergyData: SynergyApplication = SynergyApplication.new()
	for slot: EmployeeContainer in grid.values():
		if slot.employee != null && slot.employee != employee:
			synergyData.apply_employee_synergies(slot.employee, employee)
	speed_mult = (speed_mult + synergyData.flatTime) * synergyData.multTime
	employee.start_production(speed_mult)

const patterns: Dictionary[String, Array] = {
	"Intern Together Strong":[
		["Intern Developer", "Intern Developer", "Intern Developer"],
		["Intern Developer", "Intern Developer", "Intern Developer"],
		["Intern Developer", "Intern Developer", "Intern Developer"]
	],
	"Rubber Ducking":[
		["Rubber Ducky", "Rubber Ducky", "Rubber Ducky"],
		["Rubber Ducky", "Developer", "Rubber Ducky"],
		["Rubber Ducky", "Rubber Ducky", "Rubber Ducky"]
	]
}

func check_grid_for_relics() -> void:
	if !CorporateSim.instance.relic_inventory.has_relic("Intern Together Strong") && check_for_pattern(patterns["Intern Together Strong"]):
		CorporateSim.instance.give_relic(load("res://Scenes/Relics/InternTogetherStrong.tscn").instantiate())
	if !CorporateSim.instance.relic_inventory.has_relic("Rubber Ducking") && check_for_pattern(patterns["Rubber Ducking"]):
		CorporateSim.instance.give_relic(load("res://Scenes/Relics/RubberDucking.tscn").instantiate())

func check_for_pattern(pattern: Array) -> bool:
	for key: Vector2i in grid.keys():
		if key[0] > (columns - pattern.size()) || key[1] > (columns - pattern[0].size()):
			continue
		var employee: Employee = grid[key].employee
		if pattern[0][0] == "X" || (employee == null && pattern[0][0] == "") || (employee != null && (employee.id == pattern[0][0] || employee.type == pattern[0][0] || employee.rarity == pattern[0][0])):
			var is_match: bool = true
			for row: int in range(pattern.size()):
				for col: int in range(pattern[0].size()):
					employee = grid[key + Vector2i(row, col)].employee
					if !(pattern[row][col] == "X" || (employee == null && pattern[row][col] == "") || (employee != null && (employee.id == pattern[row][col] || employee.type == pattern[row][col] || employee.rarity == pattern[0][0]))):
						is_match = false
						break
				if !is_match:
					break
			if is_match:
				return true
	return false

func get_actual_cursor_grid_pos() -> Vector2i:
	var cursor_pos: Vector2 = get_local_mouse_position()
	if cursor_pos.x < 0:
		cursor_pos.x -= 32
	if cursor_pos.y < 0:
		cursor_pos.y -= 32
	cursor_pos /= 32
	@warning_ignore("narrowing_conversion")
	return Vector2i(cursor_pos.y, cursor_pos.x)

func get_cursor_grid_pos() -> Vector2i:
	var cursor_grid_pos: Vector2i = get_actual_cursor_grid_pos()
	if cursor_grid_pos.x < 0 || cursor_grid_pos.y < 0:
		return Vector2i(-1, -1)
	if cursor_grid_pos.x >= columns || cursor_grid_pos.y >= columns:
		return Vector2i(-1, -1)
	return cursor_grid_pos

func _input(event: InputEvent) -> void:
	if disabled:
		return
	if event is InputEventMouseButton:
		if event.is_action_pressed("left_click"):
			var cursor_grid_pos: Vector2i = get_cursor_grid_pos()
			if cursor_grid_pos != Vector2i(-1, -1) && grid[cursor_grid_pos].employee != null:
				held = grid[cursor_grid_pos].employee
				held.global_position = get_global_mouse_position() - held.size/2
				held.z_index += 1
				description.hide_description(self)
				description.change_show_locked(true, self)
				@warning_ignore("integer_division")
				sell_text.text = "Sell for %s coins" % (ShopSlot.get_cost(held.rarity)/2)
				sell_area.show()
		elif event.is_action_released("left_click") && held != null:
			var cursor_grid_pos: Vector2i = get_cursor_grid_pos()
			held.z_index -= 1
			if hovering_sell:
				grid[held.grid_pos].employee = null
				held.queue_free()
				money_produced.emit(25)
				last_change = Time.get_ticks_msec()
			elif cursor_grid_pos != Vector2i(-1, -1):
				grid[held.grid_pos].switch_employee(grid[cursor_grid_pos], cursor_grid_pos)
				check_grid_for_relics()
				last_change = Time.get_ticks_msec()
			else:
				held.position = Vector2.ZERO
			held = null
			sell_area.hide()
			description.change_show_locked(false, self)
	if event is InputEventMouseMotion:
		if held != null:
			held.position += event.relative
			if !paint_locked:
				paint_synergies(held, get_actual_cursor_grid_pos())
		var cursor_grid_pos: Vector2i = get_cursor_grid_pos()
		if highlighted_container != Vector2i(-1, -1):
			if grid.get(highlighted_container) != null:
				grid[highlighted_container].highlight.hide()
		if cursor_grid_pos != Vector2i(-1, -1):
			if held == null && grid[cursor_grid_pos].employee == null && !paint_locked:
				unpaint_synergies()
			if highlight_filled || grid[cursor_grid_pos].employee == null:
				grid[cursor_grid_pos].highlight.show()
			if grid[cursor_grid_pos].employee != null && held == null:
				description.show_description(grid[cursor_grid_pos].employee.description, self)
				if !paint_locked:
					paint_synergies(grid[cursor_grid_pos].employee)
			else:
				description.hide_description(self)
		else:
			if held == null && !paint_locked:
				unpaint_synergies()
			description.hide_description(self)
		highlighted_container = cursor_grid_pos

func employee_production(employee: Employee) -> void:
	var production_worth: int = employee.production_value
	var speed_mult: float = 1.0
	var synergyData: SynergyApplication = SynergyApplication.new()
	for slot: EmployeeContainer in grid.values():
		if slot.employee != null:
			synergyData.apply_employee_synergies(slot.employee, employee)
	production_worth = roundi((production_worth + synergyData.flatValue) * synergyData.multValue)
	speed_mult = (speed_mult + synergyData.flatTime) * synergyData.multTime
	if production_worth < 0:
		if CorporateSim.instance.relic_inventory.has_relic("Turning Losses (Around)"):
			production_worth *= -1
		else:
			negatives_earned += 1
			if negatives_earned > 5:
				CorporateSim.instance.give_relic(load("res://Scenes/Relics/TurningLosses.tscn").instantiate())
	if CorporateSim.instance.relic_inventory.has_relic("Employee Stability"):
		production_worth *= 2
	money_produced.emit(production_worth)
	employee.create_production_text(production_worth)
	employee.start_production(speed_mult)

func _on_sell_area_mouse_entered() -> void:
	sell_area.modulate.a = 0.8
	hovering_sell = true

func _on_sell_area_mouse_exited() -> void:
	sell_area.modulate.a = 0.6
	hovering_sell = false

func paint_synergies(employee: Employee, temp_pos: Vector2i=Vector2i(-99999, -99999)) -> void:
	if temp_pos == Vector2i(-99999, -99999):
		temp_pos = employee.grid_pos
	var synergyData: SynergyApplication = SynergyApplication.new()
	for key: Vector2i in grid.keys():
		if key != temp_pos:
			var slot: EmployeeContainer = grid[key]
			if slot.employee == null || key == temp_pos:
				slot.highlight.self_modulate = synergyData.get_highlight_color_null(employee, key, temp_pos)
			else:
				slot.highlight.self_modulate = synergyData.get_highlight_color(employee, slot.employee, temp_pos)
			slot.highlight.show()
		else:
			grid[key].reset_highlight_modulate()

func unpaint_synergies() -> void:
	for slot: EmployeeContainer in grid.values():
		slot.reset_highlight_modulate()
		slot.highlight.hide()

func interrupt_hold() -> void:
	if held != null:
		held.position = Vector2.ZERO
		held.z_index -= 1
		held = null
		sell_area.hide()
		description.change_show_locked(false, self)

func get_employee_count(id: String) -> int:
	var count: int = 0
	for container: EmployeeContainer in grid.values():
		if container.employee == null:
			if id == "":
				count += 1
		elif container.employee.id == id:
			count += 1
	return count

func has_employee(id: String) -> bool:
	for container: EmployeeContainer in grid.values():
		if container.employee == null:
			if id == "":
				return true
		elif container.employee.id == id:
			return true
	return false
