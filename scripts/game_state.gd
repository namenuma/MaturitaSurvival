extends Node

signal stress_changed(value: float)
signal stress_maxed

const MAX_STRESS := 100.0
var stress := 0.0

func add_stress(amount: float) -> void:
	set_stress(stress + amount)

func set_stress(value: float) -> void:
	stress = clampf(value, 0.0, MAX_STRESS)
	stress_changed.emit(stress)
	if stress >= MAX_STRESS:
		stress_maxed.emit()
