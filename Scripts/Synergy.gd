class_name Synergy extends Resource

enum Types {
	FLAT,
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
@export var area: Array[Vector2i]
