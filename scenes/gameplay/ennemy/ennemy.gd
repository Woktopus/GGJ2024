extends CharacterBody2D
class_name Ennemy


const SPEED = 75.0
const MAX_HEALTH = 2



@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@export var player : CharacterBody2D
@onready var sprite = $AnimatedSprite2D

@export var path : Path2D
@export var playerAreaDetection: Area2D

var lootScene = preload("res://scenes/gameProps/gunDrop.tscn")
var deadBodyScene = preload("res://scenes/gameProps/deadBody.tscn")
var bloodScene = preload("res://scenes/gameProps/blood.tscn")
var healthPoint : int 

var actual_point = 1
var isPlayerDetected = false
var point_actualised=true

var moveTo = Vector2(0,0)

func _ready():
	player = get_parent().get_node("player")
	$Timer.start()
	healthPoint = MAX_HEALTH
	nav_agent.target_reached.connect(_on_navigation_finished)
	playerAreaDetection.body_entered.connect(_on_body_enter_area)

func _physics_process(_delta):
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = dir * SPEED
	sprite.look_at(player.global_position)
	move_and_slide()
	
func makepath():
	if isPlayerDetected == false && point_actualised:
		var pos = path.curve.get_point_position(actual_point)
		pos.x = pos.x + path.position.x
		pos.y = pos.y + path.position.y
		nav_agent.target_position = pos
		print("navigate to : " + str(nav_agent.target_position))
		point_actualised=false
	else:
		if isPlayerDetected:
			nav_agent.target_position = player.global_position

func kill():
	var rng = RandomNumberGenerator.new()
	var my_random_radius = rng.randf_range(0.0, 360.0)
	healthPoint -= 1
	if healthPoint > 0 :
		var blood = bloodScene.instantiate()
		blood.position = global_position
		blood.set_rotation(my_random_radius)
		get_parent().add_child(blood)
		print("print blood")
	else :
		player.hasKill()
		# spawn dead body on death 
		var deadBody = deadBodyScene.instantiate()
		deadBody.position = global_position
		deadBody.set_rotation(my_random_radius)
		#deadBody.
		get_parent().add_child(deadBody)
		print("print dead body")
		
		# chance to spawn ammo on death 
		var my_random_number = rng.randf_range(0.0, 100.0)
		if my_random_number >= 60.0 :
			var loot  = lootScene.instantiate()
			loot.position = global_position
			loot.rotation_degrees = rotation_degrees
			#loot.direction = Vector2.RIGHT.rotated(rotation)
			get_parent().add_child(loot)
			print("drop ammo!")
		
		# Add time to timer
		
		var funTimer = get_parent().get_node("FunTimer")
		var timeLeft = funTimer.time_left
		funTimer.stop()
		print(timeLeft)
		var newTime = timeLeft + 3.0
		print(timeLeft)
		if newTime > PlayersInfos.funTimerMaxValue :
			newTime = PlayersInfos.funTimerMaxValue
		print(timeLeft)
		funTimer.start(newTime)
		
		# increase ennemies death counter
		get_parent().increase_enemies_kill()
		
		# free current ennemie
		queue_free()

func _on_timer_timeout():
	makepath()


func _on_area_2d_body_entered(body):
	if body.name == "player":
		body.takeDamage(velocity)
		
func _on_navigation_finished():
	if isPlayerDetected == false && point_actualised == false:
		#moveTo = Vector2(0,400)
		#point_actualised = true
		actual_point+=1
		actual_point = actual_point % path.curve.point_count
		point_actualised = true

func _on_body_enter_area(body):
	print(body.name + "entered")
	if body.name == "player":
		isPlayerDetected = true
