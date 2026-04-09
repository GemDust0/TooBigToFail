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
