class_name RelicInventory extends TileMapLayer

var relics: Array[Relic] = []
var hovered: Relic = null

@onready var container: FlowContainer = $RelicContainer
@onready var description: DescriptionLabel = %DescriptionLabel

func has_relic(id: String) -> bool:
	for relic: Relic in relics:
		if relic.id == id:
			return true
	return false

func add_relic(relic: Relic) -> void:
	relics.append(relic)
	container.add_child(relic)
	relic.mouse_entered_relic.connect(mouse_entered_relic)
	relic.mouse_exited_relic.connect(mouse_exited_relic)

func mouse_entered_relic(relic: Relic) -> void:
	hovered = relic
	description.show_description("%s\n[color=#%s]%s[/color]" % [relic.id, Employee.static_get_rarity_color("Common").to_html(), relic.description], self)
	description.change_show_locked(true, self)

func mouse_exited_relic(relic: Relic) -> void:
	if relic == hovered:
		hovered = null
		description.hide_description(self)
		description.change_show_locked(false, self)
