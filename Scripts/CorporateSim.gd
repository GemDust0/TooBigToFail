class_name CorporateSim extends Node

signal money_changed(money: int)

@export var employeeContainer: PackedScene
var gridSize: int = 10
var money: int = 0:
	set(value):
		money = value
		moneyLabel.text = str(money)
		money_changed.emit(money)
var targets: Array[int] = [5000, 100000, 10000000, 1000000000, 100000000000]

@onready var grid: EmployeeGrid = $PanelContainer/EmployeeGrid
@onready var moneyLabel: Label = $HUD/MoneyCount
@onready var shop: EmployeeShop = $EmployeeShop
@onready var target_label: Label = $HUD/MoneyTarget
@onready var relic_inventory: RelicInventory = $RelicInventory

static var instance: CorporateSim = null

func _enter_tree() -> void:
	instance = self

func _ready() -> void:
	money = 250
	#money = 1000000000
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
	if targets.size() == 0:
		$HUD/TargetReached/TargetAchieved.text = " TARGET ACHIEVED \n\nYou may rest.\n\n" % targets[0]
	else:
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

func start_subsidy_timer() -> void:
	var timer: SceneTreeTimer = get_tree().create_timer(5)
	timer.timeout.connect(add_money.bind(100))
	timer.timeout.connect(start_subsidy_timer)

func give_relic(relic: Relic) -> void:
	if !$HUD/TargetReached.visible:
		relic_inventory.process_mode = Node.PROCESS_MODE_DISABLED
		%RelicName.text = relic.id
		%RelicTexture.texture = relic.texture
		%RelicDescription.text = relic.description
		%RelicUnlock.visible = true
	relic_inventory.add_relic(relic)
	
func accept_relic() -> void:
	%RelicUnlock.visible = false
	relic_inventory.process_mode = Node.PROCESS_MODE_INHERIT
