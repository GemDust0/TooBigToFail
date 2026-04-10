extends Node

const save_path: String = "Save.txt"

var loaded_file: FileAccess = null;
var save_node: Node = null
var loaded: bool = false
var save_file: FileAccess

func save() -> void:
	save_file = FileAccess.open(save_path, FileAccess.WRITE)
	save_file.store_float(AudioPlayer.volume_db)
	if save_node is CorporateSim:
		save_corporate_sim()
	elif save_node is EmployeeSequence:
		save_employee_sequence()
	elif save_node is Dialogue:
		save_dialogue()

func save_corporate_sim() -> void:
	save_file.store_pascal_string("C")
	save_file.store_64(save_node.money)
	save_file.store_var(save_node.targets)
	save_file.store_64(save_node.grid.columns)
	for key: Vector2i in save_node.grid.grid.keys():
		save_file.store_var(key)
		var employee: Employee = save_node.grid.grid[key].employee
		if employee == null:
			save_file.store_pascal_string("")
		else:
			save_file.store_pascal_string(employee.id)
	save_file.store_64(save_node.relic_inventory.relics.size())
	for relic: Relic in save_node.relic_inventory.relics:
		save_file.store_pascal_string(relic.id)
	for slot: ShopSlot in save_node.shop.slots:
		if slot.locked:
			save_file.store_pascal_string("locked")
		elif slot.employee == null:
			save_file.store_pascal_string("")
		else:
			save_file.store_pascal_string(slot.employee.id)
	save_file.store_64(save_node.shop.shop_level)
	
func save_employee_sequence() -> void:
	save_file.store_pascal_string("E")
	save_file.store_var(save_node.scores)
	save_file.store_64(save_node.code_index)
	save_file.store_var(save_node.codeEditor.inputNode.text)
	save_file.store_64(save_node.codeEditor.inputNode.get_caret_line())
	save_file.store_64(save_node.codeEditor.inputNode.get_caret_column())

func save_dialogue() -> void:
	save_file.store_pascal_string("D")
	save_file.store_pascal_string(save_node.get_parent().name)
	save_file.store_64(save_node.dialogue_index)
	save_file.close()

func attempt_load() -> void:
	if FileAccess.file_exists(save_path):
		loaded_file = FileAccess.open(save_path, FileAccess.READ)
		AudioPlayer.volume_db = loaded_file.get_float()
		print(AudioPlayer.volume_db)

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
