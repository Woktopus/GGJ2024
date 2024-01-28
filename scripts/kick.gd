extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	#$interneKickStarter
	print("coucou")
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = get_parent().position



func _on_kick_timer_timeout():
	#queue_free()
	pass
