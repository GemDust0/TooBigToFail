extends Node

@export var codeArray: PackedStringArray
@export var faces: Array[Texture2D] = [null, null, null]
var scores: PackedFloat32Array = PackedFloat32Array()
var code_index: int = 0

@onready var codeEditor: CodeEditor = $CodeEditor
@onready var performanceText: Label = $HUD/PerformanceText
@onready var performanceIcon: Sprite2D = $HUD/PerformanceIcon
@onready var workProgress: Label = $HUD/WorkProgress

func _ready() -> void:
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
		print(get_final_score())
		get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn")

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
