extends Control

signal ended
signal dialogueContinued(dialogue_index: int)
signal curTextEnded(dialogue_index: int)

@export var dialogue: PackedStringArray
var dialogue_index: int

@onready var label: RichTextLabel = $Text
@onready var character_timer: Timer = $CharacterTimer
@onready var space_timer: Timer = $SpaceTimer
@onready var period_timer: Timer = $PeriodTimer
@onready var continue_label: Label = $Continue

func _ready() -> void:
	label.visible_characters = 0

func stop_timers() -> void:
	character_timer.stop()
	space_timer.stop()
	period_timer.stop()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("enter"):
		if label.visible_characters < dialogue[dialogue_index].length():
			label.visible_characters = dialogue[dialogue_index].length()
			stop_timers()
			continue_label.show()
			curTextEnded.emit(dialogue_index)
		else:
			dialogue_index += 1
			if dialogue_index < dialogue.size():
				label.visible_characters = 0
				label.text = dialogue[dialogue_index]
				character_timer.start()
				continue_label.hide()
				dialogueContinued.emit(dialogue_index)
			else:
				ended.emit()

func _on_timer_timeout() -> void:
	label.visible_characters += 1
	
	if label.visible_characters == dialogue[dialogue_index].length():
		continue_label.show()
		curTextEnded.emit(dialogue_index)
	else:
		var character: String = label.text.substr(label.visible_characters - 1, 1)
		if character in [" ", ","]:
			space_timer.start()
		elif character in [".", "?", "!"]:
			period_timer.start()
		else:
			character_timer.start()
