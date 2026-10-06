extends CanvasLayer

@onready var label: Label = $Panel/Label

var lines: Array[String] = []
var index := 0
var is_open := false
var tween: Tween


func _ready() -> void:
	hide()


func start(new_lines: Array[String]) -> void:
	if new_lines.is_empty():
		return
	lines = new_lines
	index = 0
	is_open = true
	show()
	_show_line()


func _show_line() -> void:
	label.text = lines[index]
	label.visible_ratio = 0.0
	tween = create_tween()
	tween.tween_property(label, "visible_ratio", 1.0, lines[index].length() * 0.03)


func _unhandled_input(event: InputEvent) -> void:
	if not is_open or not event.is_action_pressed("interact"):
		return
	get_viewport().set_input_as_handled()
	if tween and tween.is_running():
		tween.kill()
		label.visible_ratio = 1.0
	else:
		index += 1
		if index >= lines.size():
			is_open = false
			hide()
		else:
			_show_line()
