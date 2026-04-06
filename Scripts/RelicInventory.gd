class_name RelicInventory extends TileMapLayer

var relics: Array[Relic] = []

@onready var container: FlowContainer = $RelicContainer

func has_relic(id: String) -> bool:
	for relic: Relic in relics:
		if relic.id == id:
			return true
	return false

func add_relic(relic: Relic) -> void:
	relics.append(relic)
	container.add_child(relic)
