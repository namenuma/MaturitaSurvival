extends CanvasLayer

@onready var bar: ProgressBar = $HBoxContainer/Bar
var tween: Tween

func _ready() -> void:
	bar.max_value = GameState.MAX_STRESS
	_on_stress_changed(GameState.stress, true)
	GameState.stress_changed.connect(_on_stress_changed)

func _on_stress_changed(value: float, instant := false) -> void:
	if tween:
		tween.kill()
	if instant:
		bar.value = value
	else:
		tween = create_tween()
		tween.tween_property(bar, "value", value, 0.25)
#AI assisted
	var fill := bar.get_theme_stylebox("fill") as StyleBoxFlat
	fill.bg_color = Color.GREEN.lerp(Color.RED, value / GameState.MAX_STRESS)
