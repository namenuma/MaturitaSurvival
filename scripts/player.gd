extends CharacterBody2D

@export var speed := 150.0
var facing := "down"

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	if DialogueBox.is_open:
		velocity = Vector2.ZERO
		move_and_slide()
		anim.stop()
		anim.frame = 0
		return

	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	move_and_slide()
	update_animation(direction)
#AI assisted:
func update_animation(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		if abs(direction.x) > abs(direction.y):
			facing = "right" if direction.x > 0 else "left"
		else:
			facing = "down" if direction.y > 0 else "up"
		anim.play("walk_" + facing)
	else:
		anim.stop()
		anim.frame = 0
#end of AI assist
