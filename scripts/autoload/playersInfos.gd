class_name playerInfos
extends Node

# player status infos
const maxHealthPoint = 5
const startHealthPoint = 3
var healthPoint = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	healthPoint = startHealthPoint
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
