class_name ProductionText extends Label

@onready var production_sound: AudioStreamPlayer = $ProductionSound

func _ready() -> void:
	production_sound.pitch_scale = randf()*0.2+0.8
	production_sound.volume_db = AudioPlayer.volume_db
