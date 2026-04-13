class_name Relic extends TextureRect

const lookup: Dictionary[String, String] = {
	"Added A Tutorial":"res://Scenes/Relics/AddedATutorial.tscn",
	"Amateur Hour":"res://Scenes/Relics/AmateurHour.tscn",
	"Analysis Squared":"res://Scenes/Relics/AmateurHour.tscn",
	"Cats And Dogs":"res://Scenes/Relics/CatsAndDogs.tscn",
	"Government Subsidies":"res://Scenes/Relics/GovernmentSubsidies.tscn",
	"Intern Together Strong":"res://Scenes/Relics/InternTogetherStrong.tscn",
	"Management Overhaul":"res://Scenes/Relics/ManagementOverhaul.tscn",
	"Mentorship":"res://Scenes/Relics/AmateurHour.tscn",
	"Mutualism":"res://Scenes/Relics/Mutualism.tscn",
	"Proper Documentation":"res://Scenes/Relics/AmateurHour.tscn",
	"Remaster In Rust":"res://Scenes/Relics/AmateurHour.tscn",
	"Rubber Ducking":"res://Scenes/Relics/RubberDucking.tscn",
	"Snitches get... Snitches??":"res://Scenes/Relics/SnitchesSnitches.tscn",
	"Employee Stability":"res://Scenes/Relics/Stability.tscn",
	"Support Circle":"res://Scenes/Relics/AmateurHour.tscn",
	"Turning Losses (Around)":"res://Scenes/Relics/TurningLosses.tscn"
}

@export var id: String
@export var description: String

signal mouse_entered_relic(relic: Relic)
signal mouse_exited_relic(relic: Relic)

func _ready() -> void:
	mouse_entered.connect(mouse_entered_relic.emit.bind(self))
	mouse_exited.connect(mouse_exited_relic.emit.bind(self))
