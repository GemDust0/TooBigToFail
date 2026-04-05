extends TileMapLayer

func restock() -> void:
	$Slots/ShopSlot.set_employee(load("res://Scenes/Employees/InternDeveloper.tscn").instantiate())
