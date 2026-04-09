class_name Relic extends TextureRect

const lookup: Dictionary[String, String] = {
	"Amateur Hour":"res://Scenes/Relics/AmateurHour.tscn",
	"Cats And Dogs":"res://Scenes/Relics/CatsAndDogs.tscn",
	"Government Subsidies":"res://Scenes/Relics/GovernmentSubsidies.tscn",
	"Intern Together Strong":"res://Scenes/Relics/InternTogetherStrong.tscn",
	"Management Overhaul":"res://Scenes/Relics/ManagementOverhaul.tscn",
	"Mutualism":"res://Scenes/Relics/Mutualism.tscn",
	"Rubber Ducking":"res://Scenes/Relics/RubberDucking.tscn",
	"Snitches get... Snitches??":"res://Scenes/Relics/SnitchesSnitches.tscn",
	"Employee Stability":"res://Scenes/Relics/Stability.tscn",
	"Turning Losses (Around)":"res://Scenes/Relics/TurningLosses.tscn"
}

@export var id: String
@export var description: String

signal mouse_entered_relic(relic: Relic)
signal mouse_exited_relic(relic: Relic)

func _ready() -> void:
	mouse_entered.connect(mouse_entered_relic.emit.bind(self))
	mouse_exited.connect(mouse_exited_relic.emit.bind(self))
