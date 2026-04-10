extends AudioStreamPlayer

var max_volume: int = 4
var default_volume: int = 2

var max_sfx_volume: int = 4
var cur_sfx_volume: float = 2

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	stream = AudioStreamMP3.load_from_file("res://Assets/gabrieleromanoy-relax-synth-275097.mp3")
	stream.loop = true
	volume_linear = default_volume
	play()
