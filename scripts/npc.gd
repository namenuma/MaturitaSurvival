extends StaticBody2D

@export var lines: Array[String] = ["Ahoj!", "Dneska je hezky, ze?"]

var player_in_range := false

@onready var prompt: Label = $Prompt


func _ready() -> void:
	prompt.hide()
	%InteractArea.body_entered.connect(_on_body_entered)
	%InteractArea.body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		prompt.show()


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		prompt.hide()


func _unhandled_input(event: InputEvent) -> void:
	if player_in_range and not DialogueBox.is_open and event.is_action_pressed("interact"):
		DialogueBox.start(lines)
		get_viewport().set_input_as_handled()
