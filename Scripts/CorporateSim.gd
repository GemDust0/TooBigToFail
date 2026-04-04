extends Node

@export var employeeContainer: PackedScene

var gridSize: int = 10
@onready var employeeGrid: EmployeeGrid = $PanelContainer/EmployeeGrid

func _ready() -> void:
	employeeGrid.create_grid(5)

func _on_button_pressed() -> void:
	employeeGrid.increase_grid_size(1)

func _on_button_2_pressed() -> void:
	employeeGrid.decrease_grid_size(1)
