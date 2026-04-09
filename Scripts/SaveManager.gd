extends Node

const save_path: String = "Save.txt"

var loaded_file: FileAccess = null;
var save_node: Node = null
var loaded: bool = false

func save() -> void:
	if save_node is CorporateSim:
		save_corporate_sim()
	elif save_node is EmployeeSequence:
		save_employee_sequence()
	elif save_node is Dialogue:
		save_dialogue()

func save_corporate_sim() -> void:
	var file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_pascal_string("C")
	file.store_64(save_node.money)
	file.store_var(save_node.targets)
	file.store_64(save_node.grid.columns)
	for key: Vector2i in save_node.grid.grid.keys():
		file.store_var(key)
		var employee: Employee = save_node.grid.grid[key].employee
		if employee == null:
			file.store_pascal_string("")
		else:
			file.store_pascal_string(employee.id)
	file.store_64(save_node.relic_inventory.relics.size())
	for relic: Relic in save_node.relic_inventory.relics:
		file.store_pascal_string(relic.id)
	for slot: ShopSlot in save_node.shop.slots:
		if slot.locked:
			file.store_pascal_string("locked")
		elif slot.employee == null:
			file.store_pascal_string("")
		else:
			file.store_pascal_string(slot.employee.id)
	file.store_64(save_node.shop.shop_level)
	
func save_employee_sequence() -> void:
	var file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_pascal_string("E")
	file.store_var(save_node.scores)
	file.store_64(save_node.code_index)
	file.store_var(save_node.codeEditor.inputNode.text)
	file.store_64(save_node.codeEditor.inputNode.get_caret_line())
	file.store_64(save_node.codeEditor.inputNode.get_caret_column())

func save_dialogue() -> void:
	var file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_pascal_string("D")
	file.store_pascal_string(save_node.get_parent().name)
	file.store_64(save_node.dialogue_index)
	file.close()

func attempt_load() -> void:
	if FileAccess.file_exists(save_path):
		loaded_file = FileAccess.open(save_path, FileAccess.READ)

func transition_to_saved(transition_object: TransitionObject) -> void:
	match loaded_file.get_pascal_string():
		"C":
			loaded = true
			transition_object.change_scene(load("res://Scenes/CorporateSim.tscn"))
		"E":
			loaded = true
			transition_object.change_scene(load("res://Scenes/EmployeeSequence.tscn"))
		"D":
			loaded = true
			transition_object.change_scene(load("res://Scenes/Cutscenes/%s.tscn" % loaded_file.get_pascal_string()))
	if loaded:
		await get_tree().scene_changed
		loaded = false
