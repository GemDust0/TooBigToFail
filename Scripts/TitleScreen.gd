extends Node

@onready var transition_object: TransitionObject = $CanvasLayer/TransitionObject

func _ready() -> void:
	SaveManager.save_node = null
	if SaveManager.loaded_file != null:
		$CanvasLayer/VBoxContainer/ContinueGame.disabled = false

func _on_new_game_pressed() -> void:
	transition_object.change_scene(load("res://Scenes/Cutscenes/IntroductionCutscene.tscn"))

func _on_exit_game_pressed() -> void:
	SaveManager.save()
	get_tree().quit()

func _on_continue_game_pressed() -> void:
	SaveManager.transition_to_saved(transition_object)
