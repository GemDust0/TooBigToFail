class_name SynergyApplication extends Resource

var flatValue: float = 0.0
var flatTime: float = 1.0
var multValue: float = 1.0
var multTime: float = 1.0

func apply_employee_synergies(employee: Employee, target_employee: Employee) -> void:
	for synergy: Synergy in employee.synergies:
		if synergy.check_apply(employee.grid_pos, target_employee):
			match synergy.type:
				Synergy.Types.FLAT:
					match synergy.stat:
						Synergy.Stats.VALUE:
							flatValue += synergy.effect
						Synergy.Stats.SPEED:
							flatTime += synergy.effect
				Synergy.Types.ADDITIVE_MULTIPLICATIVE:
					match synergy.stat:
						Synergy.Stats.VALUE:
							multValue += synergy.effect
						Synergy.Stats.SPEED:
							multTime += synergy.effect
				Synergy.Types.MULTIPLICATIVE:
					match synergy.stat:
						Synergy.Stats.VALUE:
							multValue *= synergy.effect
						Synergy.Stats.SPEED:
							multTime *= synergy.effect

func get_highlight_color(employee: Employee, target_employee: Employee, temp_pos: Vector2i=Vector2i(-1, -1)) -> Color:
	var highlight_color: Color = Color(0.0, 0.0, 0.0, 0.0)
	if temp_pos == Vector2i(-99999, -99999):
		temp_pos = employee.grid_pos
	for synergy: Synergy in employee.synergies:
		if synergy.check_in_range(temp_pos, target_employee.grid_pos):
			if synergy.check_affects(target_employee.id):
				highlight_color = Color(0.0, 1.0, 0.0, 0.9)
				break
			else:
				highlight_color = Color(1.0, 0.0, 0.0, 0.9)
	return highlight_color

func get_highlight_color_null(employee: Employee, target_pos: Vector2i, temp_pos: Vector2i=Vector2i(-1, -1)) -> Color:
	var highlight_color: Color = Color(0.0, 0.0, 0.0, 0.0)
	if temp_pos == Vector2i(-99999, -99999):
		temp_pos = employee.grid_pos
	for synergy: Synergy in employee.synergies:
		if synergy.check_in_range(temp_pos, target_pos):
			return Color(1.0, 0.0, 0.0, 0.8)
	return highlight_color
