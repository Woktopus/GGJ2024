extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	#$interneKickStarter
	print("coucou")
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player = get_parent().get_node("player")
	position = player.position
	rotation_degrees = player.rotation_degrees



func _on_kick_timer_timeout():
	queue_free()
	


func _on_body_entered(body):
	if "ennemy" in body.name:
		body.kill()
