class_name TransitionObject extends ColorRect

@export var should_fade_in: bool = true
@export var fade_in_delay: float = 0.5

@onready var animation_player: AnimationPlayer = $Fade

func _ready() -> void:
	if should_fade_in:
		fade_in()

func change_scene(scene: PackedScene) -> void:
	get_tree().paused = true
	mouse_filter = Control.MOUSE_FILTER_STOP
	animation_player.play("fade_out")
	await animation_player.animation_finished
	get_tree().paused = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	get_tree().change_scene_to_packed(scene)

func fade_in() -> void:
	get_tree().paused = true
	mouse_filter = Control.MOUSE_FILTER_STOP
	color.a = 1.0
	await get_tree().create_timer(fade_in_delay).timeout
	animation_player.play("fade_in")
	await animation_player.animation_finished
	get_tree().paused = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE
