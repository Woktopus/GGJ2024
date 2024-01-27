extends CharacterBody2D


const SPEED = 100.0


@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@export var player : CharacterBody2D
@onready var sprite = $AnimatedSprite2D

func _ready():
	player = get_parent().get_node("player")
	$Timer.start()

func _physics_process(delta):
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = dir * SPEED

	#position += (player.position - position) / 50
	sprite.look_at(player.global_position)
	move_and_slide()
	
func makepath():
	nav_agent.target_position = player.global_position

func kill():
	queue_free()


func _on_timer_timeout():
	makepath()
