extends Area2D

var speed = 500
var direction = Vector2.RIGHT

func _physics_process(delta):
	var velocity = direction * speed * delta
	global_position += velocity



func _on_body_entered(body):
	if "ennemy" in body.name:
		queue_free()
		body.kill()
	else:
		if body.name != "player":
			queue_free()
