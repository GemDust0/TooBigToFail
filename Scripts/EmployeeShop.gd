class_name EmployeeShop extends TileMapLayer

@export var grid: EmployeeGrid
@export var employees: Array[PackedScene]
var slot_scene: PackedScene = preload("res://Scenes/ShopSlot.tscn")
var slots: Array[ShopSlot] = []
var slot_highlight_color: Color = Color(1.0, 1.0, 1.0, 0.498)
var slot_expensive_color: Color = Color(0.65, 0.065, 0.163, 0.498)
var held: ShopSlot = null
var shop_level: int = 1
var weights: Array[int] = [0, 50, 70, 85, 95, 100]

@onready var slots_node: VBoxContainer = $Slots
@onready var slot_highlight: ColorRect = $SlotHighlight

func _ready() -> void:
	add_slot()
	add_slot()
	add_slot()
	add_slot()
	add_slot(true)
	add_slot(true)
	add_slot(true)
	add_slot(true)
	add_slot(true)

func add_slot(locked: bool = false) -> void:
	var slot: ShopSlot = slot_scene.instantiate()
	slots.append(slot)
	CorporateSim.instance.money_changed.connect(slot.update_description)
	slots_node.add_child(slot)
	if locked:
		slot.locked = true
	else:
		slot.set_employee(get_random_employee(), CorporateSim.instance.money)

func restock(ignore_cost: bool=false) -> void:
	if CorporateSim.instance.money < 50 && !ignore_cost:
		return
	elif !ignore_cost:
		CorporateSim.instance.add_money(-50)
	for slot: ShopSlot in slots:
		if slot.locked:
			break
		slot.set_employee(get_random_employee(), CorporateSim.instance.money)

func get_random_employee() -> Employee:
	var weight: int = randi() % weights[shop_level]
	var rarity: String
	for index: int in range(weights.size()-2, -1, -1):
		if weight >= weights[index]:
			rarity = ["Common", "Uncommon", "Rare", "Epic", "Legendary"][index]
			break
	var candidates: Array[Employee] = []
	for employee_scene: PackedScene in employees:
		var employee: Employee = employee_scene.instantiate()
		if employee.rarity == rarity:
			candidates.append(employee)
	return candidates[randi()%candidates.size()]

func _process(_delta: float) -> void:
	if $Disabler.visible:
		return
	if CorporateSim.instance.money < 50:
		$RestockButton.modulate = Color(0.65, 0.065, 0.163, 1.0)
		$RestockButton.disable()
	else:
		$RestockButton.modulate = Color(1, 1, 1)
		$RestockButton.undisable()
	if get_global_mouse_position().y < slots_node.global_position.y:
		grid.description.hide_description(grid.description.show_locked)
		grid.description.change_show_locked(true, self)
		if slot_highlight.visible:
			ButtonPress.play_sound(0.1, 1.1, 0.07)
			slot_highlight.hide()
		return
	var shop_cursor_pos: Vector2 = slots_node.get_local_mouse_position()
	if shop_cursor_pos.x > 0 && shop_cursor_pos.x < slots_node.size.x:
		var hovered_slot: int = int(shop_cursor_pos.y / slots_node.get_theme_constant("separation"))
		if hovered_slot < slots.size():
			if slots[hovered_slot].employee != null:
				var new_highlight_pos: int = 86 + hovered_slot*34
				if new_highlight_pos != slot_highlight.position.y || !slot_highlight.visible:
					ButtonPress.play_sound(0.1, 1.1, 0.07)
				slot_highlight.position.y = new_highlight_pos
				if CorporateSim.instance.money < slots[hovered_slot].cost:
					slot_highlight.color = slot_expensive_color
				else:
					slot_highlight.color = slot_highlight_color
				slot_highlight.show()
			else:
				slot_highlight.hide()
		else:
			slot_highlight.hide()
	else:
		slot_highlight.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") && slot_highlight.visible:
		var slot: ShopSlot = slots[(slot_highlight.position.y - 86) / 34]
		if slot.employee != null && CorporateSim.instance.money >= slot.cost:
			ButtonPress.play_sound(0.1, 1.1, 0.07)
			held = slot
			held.employeeIcon.global_position = get_global_mouse_position() - held.employeeIcon.size/2
			held.employeeIcon.z_index += 1
			grid.description.hide_description(grid.description.show_locked)
			grid.description.change_show_locked(true, self)
			grid.paint_locked = true
			grid.highlight_filled = false
		else:
			ButtonPress.play_sound(0.05, 0.6, 0.07)
			
	elif event.is_action_released("left_click") && held != null:
		var cursor_grid_pos: Vector2i = grid.get_cursor_grid_pos()
		if cursor_grid_pos != Vector2i(-1, -1) && grid.grid[cursor_grid_pos].employee == null:
			ButtonPress.play_sound(0.1, 1.1, 0.07)
			grid.add_employee(cursor_grid_pos, held.employee)
			CorporateSim.instance.add_money(-held.cost)
			held.set_employee(null)
			held.update_description(CorporateSim.instance.money)
		else:
			ButtonPress.play_sound(0.05, 0.6, 0.07)
		held.employeeIcon.position = Vector2.ZERO
		held.employeeIcon.z_index -= 1
		held = null
		grid.description.change_show_locked(false, self)
		grid.paint_locked = false
		grid.highlight_filled = true
	elif event is InputEventMouseMotion:
		if held != null:
			held.employeeIcon.position += event.relative
			grid.paint_synergies(held.employee, grid.get_actual_cursor_grid_pos())
		elif slot_highlight.visible:
			var slot: ShopSlot = slots[(slot_highlight.position.y - 86) / 34]
			if slot.employee != null:
				grid.description.show_description(slot.employee.description, self)
				grid.description.change_show_locked(true, self)
			else:
				grid.description.change_show_locked(false, self)
		else:
			grid.description.change_show_locked(false, self)

func upgrade_shop() -> void:
	shop_level += 1
	unlock_slot()

func unlock_slot() -> void:
	for slot: ShopSlot in slots:
		if slot.locked:
			slot.locked = false
			slot.set_employee(get_random_employee(), CorporateSim.instance.money)
			break

func interrupt_hold() -> void:
	if held != null:
		held.employeeIcon.position = Vector2.ZERO
		held.employeeIcon.z_index -= 1
		held = null
		grid.description.change_show_locked(false, self)
		grid.paint_locked = false
		grid.highlight_filled = true

func disable() -> void:
	$Disabler.show()

func enable() -> void:
	$Disabler.hide()
