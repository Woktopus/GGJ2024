extends CharacterBody2D


const SPEED = 75.0


@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@export var player : CharacterBody2D
@onready var sprite = $AnimatedSprite2D

var lootScene = preload("res://scenes/gameProps/gunDrop.tscn")

func _ready():
	player = get_parent().get_node("player")
	$Timer.start()

func _physics_process(_delta):
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = dir * SPEED

	#position += (player.position - position) / 50
	sprite.look_at(player.global_position)
	move_and_slide()
	
func makepath():
	nav_agent.target_position = player.global_position

func kill():
	# chance to spawn ammo on death 
	var rng = RandomNumberGenerator.new()
	var my_random_number = rng.randf_range(0.0, 100.0)
	if my_random_number >= 60.0 :
		var loot  = lootScene.instantiate()
		loot.position = global_position
		loot.rotation_degrees = rotation_degrees
		#loot.direction = Vector2.RIGHT.rotated(rotation)
		get_parent().add_child(loot)
		print("drop ammo!")
	queue_free()


func _on_timer_timeout():
	makepath()
