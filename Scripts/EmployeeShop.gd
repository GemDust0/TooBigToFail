extends TileMapLayer

@export var sim: CorporateSim
var slot_scene: PackedScene = preload("res://Scenes/ShopSlot.tscn")
var slots: Array[ShopSlot] = []

func _ready() -> void:
	add_slot()

func add_slot() -> void:
	var slot: ShopSlot = slot_scene.instantiate()
	slots.append(slot)
	sim.money_changed.connect(slot.update_description)
	$Slots.add_child(slot)

func restock() -> void:
	$Slots/ShopSlot.set_employee(load("res://Scenes/Employees/InternDeveloper.tscn").instantiate(), sim.money)
