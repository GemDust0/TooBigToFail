class_name CorporateSim extends Node

signal money_changed(money: int)

@export var employeeContainer: PackedScene
var gridSize: int = 10
var money: int = 0:
	set(value):
		money = value
		moneyLabel.text = str(money)
		money_changed.emit(money)

@onready var employeeGrid: EmployeeGrid = $PanelContainer/EmployeeGrid
@onready var moneyLabel: Label = $HUD/MoneyCount

func _ready() -> void:
	money = 250
	employeeGrid.create_grid(5)

func _on_button_pressed() -> void:
	employeeGrid.increase_grid_size(1)

func _on_button_2_pressed() -> void:
	employeeGrid.decrease_grid_size(1)

func add_money(amount: int) -> void:
	money += amount
