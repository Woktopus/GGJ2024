extends Area2D

var speed = 2000
var direction = Vector2.RIGHT

func _physics_process(delta):
	var velocity = direction * speed * delta
	global_position += velocity
