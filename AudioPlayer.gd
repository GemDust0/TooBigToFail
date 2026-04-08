extends AudioStreamPlayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	stream = AudioStreamMP3.load_from_file("res://Assets/gabrieleromanoy-relax-synth-275097.mp3")
	stream.loop = true
	play(130)
