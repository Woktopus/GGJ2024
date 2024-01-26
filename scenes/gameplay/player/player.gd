extends CharacterBody2D


const SPEED = 700.0

func _physics_process(delta):
	var direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	if direction.length() > 0:
		direction = direction.normalized() * SPEED
		velocity.x = direction.x
		velocity.y = direction.y
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	look_at(get_global_mouse_position())

	move_and_slide()
