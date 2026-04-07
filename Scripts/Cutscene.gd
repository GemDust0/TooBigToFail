extends Node

@export var transition_scene: PackedScene

@onready var transition_object: TransitionObject = $TransitionObject

func transition() -> void:
	transition_object.change_scene(transition_scene)
