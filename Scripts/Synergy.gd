class_name Synergy extends Resource

enum Types {
	ADDITIVE,
	MULTIPLICATIVE
}

enum EmployeeStats {
	VALUE,
	TIME
}

@export var affects: Array[Vector2] = []
@export var type: Types = Types.ADDITIVE
@export var effect: float = 0.0
@export var stat: EmployeeStats = EmployeeStats.VALUE
