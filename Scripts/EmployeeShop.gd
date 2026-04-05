extends TileMapLayer

func _ready() -> void:
	$Slots/ShopSlot.set_employee(load("res://Scenes/Employees/InternDeveloper.tscn").instantiate())
