extends TileMapLayer

@export var sim: CorporateSim
@export var grid: EmployeeGrid
@export var employees: Array[PackedScene]
var slot_scene: PackedScene = preload("res://Scenes/ShopSlot.tscn")
var slots: Array[ShopSlot] = []
var slot_highlight_color: Color = Color(1.0, 1.0, 1.0, 0.498)
var slot_expensive_color: Color = Color(0.65, 0.065, 0.163, 0.498)
var held: ShopSlot = null

@onready var slots_node: VBoxContainer = $Slots
@onready var slot_highlight: ColorRect = $SlotHighlight

func _ready() -> void:
	add_slot()
	add_slot()
	add_slot()
	add_slot()

func add_slot() -> void:
	var slot: ShopSlot = slot_scene.instantiate()
	slots.append(slot)
	sim.money_changed.connect(slot.update_description)
	$Slots.add_child(slot)

func restock() -> void:
	for slot: ShopSlot in slots:
		slot.set_employee(get_random_employee(), sim.money)

func get_random_employee() -> Employee:
	return employees[randi()%employees.size()].instantiate()

func _process(_delta: float) -> void:
	var shop_cursor_pos: Vector2 = slots_node.get_local_mouse_position()
	if shop_cursor_pos.x > 0 && shop_cursor_pos.x < slots_node.size.x:
		var hovered_slot: int = int(shop_cursor_pos.y / slots_node.get_theme_constant("separation"))
		if hovered_slot < slots.size():
			slot_highlight.position.y = 86 + hovered_slot*34
			if sim.money < slots[hovered_slot].cost:
				slot_highlight.color = slot_expensive_color
			else:
				slot_highlight.color = slot_highlight_color
			slot_highlight.show()
		else:
			slot_highlight.hide()
	else:
		slot_highlight.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") && slot_highlight.visible:
		var slot: ShopSlot = slots[(slot_highlight.position.y - 86) / 34]
		if slot.employee != null && sim.money >= slot.cost:
			held = slot
			held.employeeIcon.global_position = get_global_mouse_position() - held.employeeIcon.size/2
			held.employeeIcon.z_index += 1
			grid.description.hide_description(true)
			grid.description.show_locked = true
			grid.highlight_filled = false
	elif event.is_action_released("left_click") && held != null:
		var cursor_grid_pos: Vector2i = grid.get_cursor_grid_pos()
		if cursor_grid_pos != Vector2i(-1, -1):
			sim.money -= held.cost
			held.set_employee(null)
			held.update_description(sim.money)
		else:
			held.employeeIcon.position = Vector2.ZERO
		held.employeeIcon.z_index -= 1
		held = null
		grid.description.show_locked = false
		grid.highlight_filled = true
	elif event is InputEventMouseMotion:
		if held != null:
			held.employeeIcon.position += event.relative
		elif slot_highlight.visible:
			var slot: ShopSlot = slots[(slot_highlight.position.y - 86) / 34]
			if slot.employee != null:
				grid.description.show_description(slot.employee.description)
				grid.description.show_locked = true
