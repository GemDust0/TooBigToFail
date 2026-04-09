class_name CorporateSim extends Node

signal money_changed(money: int)

@export var employeeContainer: PackedScene
var gridSize: int = 10
var money: int = 0:
	set(value):
		money = value
		moneyLabel.text = str(money)
		money_changed.emit(money)
var targets: Array[int] = [10000, 100000, 500000, 2000000, 100000000]

@onready var grid: EmployeeGrid = $PanelContainer/EmployeeGrid
@onready var moneyLabel: Label = $HUD/MoneyCount
@onready var shop: EmployeeShop = $EmployeeShop
@onready var target_label: Label = $HUD/MoneyTarget
@onready var relic_inventory: RelicInventory = $RelicInventory
@onready var transition_object: TransitionObject = $HUD/TransitionObject
@onready var relic_description: Label = %RelicDescription

static var instance: CorporateSim = null

func _enter_tree() -> void:
	instance = self

func _ready() -> void:
	SaveManager.save_node = self
	if SaveManager.loaded:
		money = SaveManager.loaded_file.get_64()
		targets = SaveManager.loaded_file.get_var()
		target_label.text = "Target: %s" % targets[0]
		grid.columns = SaveManager.loaded_file.get_64()
		grid.create_grid(grid.columns)
		for i: int in grid.grid.size():
			var key: Vector2i = SaveManager.loaded_file.get_var()
			var id: String = SaveManager.loaded_file.get_pascal_string()
			if id != "":
				grid.add_employee(key, load(Employee.lookup[id]).instantiate(), false)
		for i: int in range(SaveManager.loaded_file.get_64()):
			relic_inventory.add_relic(load(Relic.lookup[SaveManager.loaded_file.get_pascal_string()]).instantiate())
		for slot: ShopSlot in shop.slots:
			var id: String = SaveManager.loaded_file.get_pascal_string()
			if id == "locked":
				slot.locked = true
			elif id == "":
				slot.set_employee(null)
			else:
				slot.set_employee(load(Employee.lookup[id]).instantiate(), money)
		shop.shop_level = SaveManager.loaded_file.get_64()
	else:
		money = 250
		#money = 100000
		#money = 100000000000
		target_label.text = "Target: %s" % targets[0]
		grid.create_grid(5)
		grid.add_employee(Vector2i(2, 2), load("res://Scenes/Employees/InternDeveloper.tscn").instantiate())

func add_money(amount: int) -> void:
	money += amount
	if !relic_inventory.has_relic("Government Subsidies") && money < ShopSlot.get_cost("Common") && grid.get_employee_count("") == grid.grid.size():
		give_relic(load("res://Scenes/Relics/GovernmentSubsidies.tscn").instantiate())
		start_subsidy_timer()
	%HandInTargetButton.disabled = (money < targets[0]) || $HUD/TargetReached.visible

func display_target_reached() -> void:
	if targets.size() == 1:
		transition_object.change_scene(load("res://Scenes/Cutscenes/FinalCutscene.tscn"))
		return # No clue if this is necessary but, in case
	if $HUD/TargetReached.visible:
		target_reached_accept()
	elif %RelicUnlock.visible:
		accept_relic()
	$HUD/TargetReached.visible = true
	grid.interrupt_hold()
	shop.interrupt_hold()
	grid.description.hide()
	shop.slot_highlight.hide()
	grid.unpaint_synergies()
	grid.disabled = true
	shop.disable()
	relic_inventory.process_mode = Node.PROCESS_MODE_DISABLED
	add_money(-targets.pop_front())
	if targets.size() == 1:
		$HUD/TargetReached/TargetAchieved.text = " TARGET ACHIEVED \n\n+ Shop Rarity\n+ 2 Shop Slots\n+ 2 Grid Size\n\n New Target: %s \n\n" % targets[0]
	else:
		$HUD/TargetReached/TargetAchieved.text = " TARGET ACHIEVED \n\n+ Shop Rarity\n+ 1 Shop Slot\n+ 1 Grid Size\n\n New Target: %s \n\n" % targets[0]
		

func target_reached_accept() -> void:
	$HUD/TargetReached.visible = false
	target_label.text = "Target: %s" % targets[0]
	grid.increase_grid_size(1)
	if targets.size() == 1:
		grid.increase_grid_size(1)
		shop.unlock_slot()
	shop.upgrade_shop()
	grid.disabled = false
	shop.enable()
	relic_inventory.process_mode = Node.PROCESS_MODE_INHERIT
	%HandInTargetButton.disabled = (money < targets[0])

func start_subsidy_timer() -> void:
	var timer: SceneTreeTimer = get_tree().create_timer(5)
	timer.timeout.connect(add_money.bind(100))
	timer.timeout.connect(start_subsidy_timer)

func give_relic(relic: Relic) -> void:
	relic_inventory.add_relic(relic)
	relic_popup.call_deferred(relic)

func relic_popup(relic: Relic) -> void:
	if !$HUD/TargetReached.visible:
		grid.interrupt_hold()
		shop.interrupt_hold()
		grid.description.hide()
		shop.slot_highlight.hide()
		grid.unpaint_synergies()
		grid.disabled = true
		shop.disable()
		relic_inventory.process_mode = Node.PROCESS_MODE_DISABLED
		%RelicName.text = relic.id
		%RelicTexture.texture = relic.texture
		relic_description.text = " %s " % relic.description
		@warning_ignore("int_as_enum_without_cast")
		relic_description.custom_minimum_size.x = min(relic_description.get_theme_font("font").get_string_size(relic_description.text, 0, -1, 11).x, 360)
		%RelicUnlock.visible = true

func accept_relic() -> void:
	%RelicUnlock.visible = false
	grid.disabled = false
	shop.enable()
	relic_inventory.process_mode = Node.PROCESS_MODE_INHERIT
