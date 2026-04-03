extends Node

@export var codeArray: PackedStringArray
var code_index: int = 0

@onready var codeEditor: CodeEditor = $CodeEditor

func _ready() -> void:
	_on_submit_pressed()

func _on_submit_pressed() -> void:
	print(codeEditor.get_correctness())
	if code_index < codeArray.size():
		codeEditor.change_code(codeArray[code_index])
		code_index += 1
	else:
		get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn")
