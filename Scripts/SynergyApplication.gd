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
