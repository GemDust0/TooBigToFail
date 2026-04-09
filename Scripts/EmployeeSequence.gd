class_name EmployeeSequence extends Node

@export var codeArray: PackedStringArray
@export var faces: Array[Texture2D] = [null, null, null]
var scores: PackedFloat32Array = PackedFloat32Array()
var code_index: int = 0

@onready var codeEditor: CodeEditor = $CodeEditor
@onready var performanceText: Label = $HUD/PerformanceText
@onready var performanceIcon: Sprite2D = $HUD/PerformanceIcon
@onready var workProgress: Label = $HUD/WorkProgress
@onready var transition_object: TransitionObject = $TransitionObject

func _ready() -> void:
	SaveManager.save_node = self
	if SaveManager.loaded:
		scores = SaveManager.loaded_file.get_var()
		code_index = SaveManager.loaded_file.get_64()
		workProgress.text = "Daily Quota: %s/%s" % [code_index, codeArray.size()]
		var performance: int = get_performance()
		performanceText.text = str(performance) + "%"
		if performance >= 90:
			performanceIcon.texture = faces[0]
		elif performance >= 50:
			performanceIcon.texture = faces[1]
		else:
			performanceIcon.texture = faces[2]
		codeEditor.change_code(codeArray[code_index - 1].replace("[\\n]", "\n").replace("[\\t]", "\t"))
		codeEditor.inputNode.text = SaveManager.loaded_file.get_var()
		codeEditor.inputNode.set_caret_line(SaveManager.loaded_file.get_64())
		codeEditor.inputNode.set_caret_column(SaveManager.loaded_file.get_64())
		codeEditor._on_input_text_changed()
		codeEditor.focus()
	else:
		_on_submit_pressed()

func _on_submit_pressed() -> void:
	workProgress.text = "Daily Quota: %s/%s" % [code_index, codeArray.size()]
	if code_index > 0:
		scores.append(codeEditor.get_correctness())
		var performance: int = get_performance()
		performanceText.text = str(performance) + "%"
		if performance >= 90:
			performanceIcon.texture = faces[0]
		elif performance >= 50:
			performanceIcon.texture = faces[1]
		else:
			performanceIcon.texture = faces[2]
	if code_index < codeArray.size():
		codeEditor.change_code(codeArray[code_index].replace("[\\n]", "\n").replace("[\\t]", "\t"))
		codeEditor.focus()
		code_index += 1
	else:
		var score: float = get_final_score()
		if score < -0.5:
			transition_object.change_scene(load("res://Scenes/Cutscenes/EmployeeNot.tscn"))
		elif score < 0.5:
			transition_object.change_scene(load("res://Scenes/Cutscenes/EmployeeBad.tscn"))
		else:
			transition_object.change_scene(load("res://Scenes/Cutscenes/EmployeeGood.tscn"))

func get_final_score() -> float:
	var finalScore: float = 0
	for score: float in scores:
		finalScore += score
	return finalScore / scores.size()

func get_performance() -> int:
	var finalScore: float = 0
	for score: float in scores:
		if score > 0:
			finalScore += score
	return int(finalScore / scores.size() * 100)
