extends TileMapLayer

@export var sim: CorporateSim
@export var employees: Array[PackedScene]
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
	for slot: ShopSlot in slots:
		slot.set_employee(get_random_employee(), sim.money)

func get_random_employee() -> Employee:
	return employees[randi_range(0, employees.size())].instantiate()
