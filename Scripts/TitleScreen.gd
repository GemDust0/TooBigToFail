extends Node

@onready var transition_object: TransitionObject = $CanvasLayer/TransitionObject

func _on_new_game_pressed() -> void:
	transition_object.change_scene("res://Scenes/EmployeeSequence.tscn")

func _on_exit_game_pressed() -> void:
	get_tree().quit()
