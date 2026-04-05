@tool
class_name Employee extends TextureRect

signal produced(employee: Employee)

@export_enum("Developer", "IT", "Pest") var type: String = "Developer"
## Money produced every production
@export var production_value: int = 50
## Time to produce
@export var production_time: float = 5.0
@export_enum("Common", "Uncommon", "Rare", "Epic", "Legendary") var rarity: String = "Common"
@export var id: String
@export var description: String = "":
	get:
		if Engine.is_editor_hint():
			return description
		return "[color=#%s]%s\n[font_size=8]%s %s[/font_size][/color]\n%s" % [get_rarity_color().to_html(), id, rarity, type, description]
@export var synergies: Array[Synergy]

var grid_pos: Vector2i
var production_text_scene: PackedScene = preload("res://Scenes/ProductionText.tscn")

@onready var production_timer: Timer = $ProductionTimer

func _ready() -> void:
	if !Engine.is_editor_hint():
		if production_time > 0:
			production_timer.wait_time = production_time
			production_timer.start()
		self_modulate = get_rarity_color()
		texture = get_icon()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		texture = get_icon()

func get_icon() -> Texture:
	match type:
		"Developer":
			return load("res://Assets/DeveloperIcon.png")
		"Pest":
			return load("res://Assets/PestIcon.png")
		_:
			return null

func produce() -> void:
	produced.emit(self)

func create_production_text(amount: int) -> void:
	var production_text: Label = production_text_scene.instantiate()
	production_text.text = "%s%s" % ["+" if amount >= 0 else "", amount]
	@warning_ignore("int_as_enum_without_cast")
	production_text.size.x = production_text.get_theme_font("font").get_string_size(production_text.text, 0, -1, 11).x + 11
	var production_tween: Tween = production_text.create_tween()
	production_tween.tween_property(production_text, "position:y", production_text.position.y-16, 1.0)
	production_tween.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	production_tween = production_text.create_tween()
	production_tween.tween_property(production_text, "modulate:a", 0.0, 0.7)
	production_tween.set_trans(Tween.TRANS_LINEAR)
	production_tween.pause()
	production_tween.finished.connect(production_text.hide)
	get_tree().create_timer(0.8).timeout.connect(production_tween.play)
	add_sibling(production_text)

func get_rarity_color() -> Color:
	match rarity:
		"Common":
			return Color(0.6, 0.6, 0.6, 1.0)
		"Uncommon":
			return Color(0.112, 0.75, 0.112, 1.0)
		"Rare":
			return Color(0.085, 0.276, 0.85, 1.0)
		"Epic":
			return Color(0.3, 0.0, 0.9, 1.0)
		"Legendary":
			return Color(1.0, 0.775, 0.1, 1.0)
		_:
			return Color(1, 1, 1)
