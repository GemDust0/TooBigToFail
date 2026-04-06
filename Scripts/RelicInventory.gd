class_name RelicInventory extends TileMapLayer

var relics: Array[Relic] = []

func has_relic(id: String) -> bool:
	for relic: Relic in relics:
		if relic.id == id:
			return true
	return false

func add_relic(relic: Relic) -> void:
	relics.append(relic)
	add_child(relic)
