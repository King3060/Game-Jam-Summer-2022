extends KinematicBody2D


export var speed := 150
export var gravity := 1_000
export var jump_force := 400

var velocity := Vector2()


func _physics_process(delta: float) -> void:
	var input := Input.get_axis("move_left", "move_right")
	velocity.x = input * speed
	velocity.y += gravity * delta
	if Input.is_action_pressed("move_up") and is_on_floor():
		velocity.y = -jump_force
	velocity = move_and_slide(velocity, Vector2.UP)
	if input != 0:
		$AnimationPlayer.play("move")
		$Sprites.scale.x = sign(input)
	else:
		$AnimationPlayer.play("RESET")
