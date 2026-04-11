extends AudioStreamPlayer

func _ready() -> void:
	stream = AudioStreamWAV.load_from_file("res://Assets/380145__yottasounds__computer-keyboard-single-key-type-5-shift.wav")

func play_sound(variation: float=0.1, base: float=1.0, start_time:float=0.05) -> void:
	pitch_scale = randf() * variation + base
	volume_db = AudioPlayer.cur_sfx_volume
	play(start_time)

func bind_button(button: BaseButton, variation: float=0.1, base: float=1.1, start_time:float=0.07) -> void:
	var function: Callable = play_sound.bind(variation, base, start_time)
	button.mouse_entered.connect(function)
	button.button_down.connect(function)
