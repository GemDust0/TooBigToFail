class_name Relic extends TextureRect

@export var id: String
@export var description: String

signal mouse_entered_relic(relic: Relic)
signal mouse_exited_relic(relic: Relic)

func _ready() -> void:
	mouse_entered.connect(mouse_entered_relic.emit.bind(self))
	mouse_exited.connect(mouse_exited_relic.emit.bind(self))
