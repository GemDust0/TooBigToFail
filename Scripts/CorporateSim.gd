class_name CorporateSim extends Node

signal money_changed(money: int)

@export var employeeContainer: PackedScene
var gridSize: int = 10
var money: int = 0:
	set(value):
		money = value
		moneyLabel.text = str(money)
		money_changed.emit(money)
var targets: Array[int] = [1000, 100000, 10000000, 1000000000, 100000000000]

@onready var grid: EmployeeGrid = $PanelContainer/EmployeeGrid
@onready var moneyLabel: Label = $HUD/MoneyCount
@onready var shop: EmployeeShop = $EmployeeShop
@onready var target_label: Label = $HUD/MoneyTarget

func _ready() -> void:
	money = 250
	target_label.text = "Target: %s" % targets[0]
	grid.create_grid(5)
	grid.add_employee(Vector2i(2, 2), load("res://Scenes/Employees/InternDeveloper.tscn").instantiate())

func add_money(amount: int) -> void:
	money += amount
	if money >= targets[0]:
		targets.pop_front()
		if targets.size() == 0:
			pass
		else:
			target_label.text = "Target: %s" % targets[0]
			grid.increase_grid_size(1)
			if targets.size() == 1:
				grid.increase_grid_size(1)
				shop.unlock_slot()
			shop.upgrade_shop()
