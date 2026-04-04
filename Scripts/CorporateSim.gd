extends Node

@export var employeeContainer: PackedScene

var gridSize: int = 10
@onready var employeeGrid: GridContainer = $PanelContainer/EmployeeGrid

func _ready() -> void:
	for i: int in range(gridSize * gridSize):
		employeeGrid.add_child(employeeContainer.instantiate())
