extends CanvasLayer

@onready var label: Label = $Panel/Label
@onready var choices_box: VBoxContainer = $Panel/Choices

var tree := {}
var current: Dictionary = {}
var is_open := false
var tween: Tween
var choosing := false
var choice_index := 0


func _ready() -> void:
	hide()
	choices_box.hide()


#  Normal Dialogue
func start(new_lines: Array[String]) -> void:
	if new_lines.is_empty():
		return
	var t := {}
	for i in new_lines.size():
		t[str(i)] = {"text": new_lines[i], "next": str(i + 1)}
	start_tree(t, "0")


# Dialogue w/ choices
func start_tree(new_tree: Dictionary, start_id := "start") -> void:
	if not new_tree.has(start_id):
		return
	tree = new_tree
	is_open = true
	show()
	_show_node(start_id)


func _show_node(id: String) -> void:
	if not tree.has(id):
		_close()
		return
	current = tree[id]
	choosing = false
	choices_box.hide()
	label.text = current["text"]
	label.visible_ratio = 0.0
	tween = create_tween()
	tween.tween_property(label, "visible_ratio", 1.0, label.text.length() * 0.03)
	tween.finished.connect(_on_text_finished)


func _on_text_finished() -> void:
	if current.has("choices"):
		_show_choices()


func _show_choices() -> void:
	choosing = true
	choice_index = 0
	for c in choices_box.get_children():
		choices_box.remove_child(c)
		c.queue_free()
	for choice in current["choices"]:
		var l := Label.new()
		l.add_theme_font_size_override("font_size", 24)
		choices_box.add_child(l)
	choices_box.show()
	_update_choices()


func _update_choices() -> void:
	for i in choices_box.get_child_count():
		var prefix := "> " if i == choice_index else "    "
		choices_box.get_child(i).text = prefix + current["choices"][i]["text"]


func _close() -> void:
	is_open = false
	choosing = false
	choices_box.hide()
	hide()


func _unhandled_input(event: InputEvent) -> void:
	if not is_open:
		return

	if choosing:
		var n: int = current["choices"].size()
		if event.is_action_pressed("ui_down"):
			choice_index = (choice_index + 1) % n
			_update_choices()
			get_viewport().set_input_as_handled()
		elif event.is_action_pressed("ui_up"):
			choice_index = (choice_index - 1 + n) % n
			_update_choices()
			get_viewport().set_input_as_handled()
		elif event.is_action_pressed("interact"):
			_show_node(current["choices"][choice_index].get("next", ""))
			get_viewport().set_input_as_handled()
		return

	if not event.is_action_pressed("interact"):
		return
	get_viewport().set_input_as_handled()
	if tween and tween.is_running():
		tween.kill()
		label.visible_ratio = 1.0
		_on_text_finished()
	elif not current.has("choices"):
		_show_node(current.get("next", ""))
