@tool
class_name Employee extends Button

enum Types {
	DEVELOPER
}

## Money produced every production
@export var type: Types = Types.DEVELOPER
@export var production_value: int = 50
## Time to produce
@export var production_time: float = 5.0
@export var description: String = ""

var held: bool = false
var grid_pos: Vector2i

@onready var production_timer: Timer = $ProductionTimer

func _ready() -> void:
	set_icon()
	production_timer.wait_time = production_time
	production_timer.start()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		set_icon()

func _input(event: InputEvent) -> void:
	if held && (event is InputEventMouseMotion):
		position += event.relative

func set_icon() -> void:
	match type:
		Types.DEVELOPER:
			$TextureRect.texture = load("res://Assets/DeveloperIcon.png")

func produce() -> void:
	pass

func _on_button_down() -> void:
	z_index += 1
	held = true

func _on_button_up() -> void:
	z_index -= 1
	held = false
	position = Vector2.ZERO
