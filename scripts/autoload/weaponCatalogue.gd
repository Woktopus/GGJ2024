extends Node

var catalogue = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	catalogue["gun"]={ maxAmmo=12, damage=1,
	texture=preload("res://assets/sprites/gameObjects/placolderGunOnFloor.png")}
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
