class_name Synergy extends Resource

enum Types {
	FLAT,
	ADDITIVE_MULTIPLICATIVE,
	MULTIPLICATIVE
}

enum Stats {
	VALUE,
	SPEED
}

@export var stat: Stats = Stats.VALUE
@export var type: Types = Types.FLAT
@export var effect: float = 0.0
## id's of affected employees
@export var affects: Array[String]
## If true will only not affect the ids in affects
@export var invertAffect: bool = false
@export var area: Array[Vector2i]
## If true will only affect those not in area
@export var invertArea: bool = false

func check_apply(grid_position: Vector2i, target_employee: Employee) -> bool:
	return check_in_range(grid_position, target_employee.grid_pos) && check_affects(target_employee.id)

func check_in_range(grid_position: Vector2i, target_pos: Vector2i) -> bool:
	return ((target_pos - grid_position) in area) != invertArea

func check_affects(target_id: String) -> bool:
	return (target_id in affects) != invertAffect
