extends CharacterBody2D

const SPEED = 150.0
const DASH_SPEED = 600.0
const DASH_TIME = 0.2
const INVU_TIME = 0.5

var is_dashing = false
var dash_timer = Timer.new()

var bulletscene = preload("res://scenes/gameplay/bullet/bullet.tscn")

var is_invu = false
var invu_timer = Timer.new() 
const KNOCKBACK_POWER = 500

@onready var cam : Camera2D = get_parent().get_node("Camera2D")

# ammo
const maxAmmo = 12
var ammoQte = 0

func _ready():
	# DASH
	add_child(dash_timer)
	dash_timer.timeout.connect(_on_dash_timer_timeout)
	dash_timer.set_one_shot(true) 
	
	# INVU Frame
	add_child(invu_timer)
	invu_timer.timeout.connect(_on_invu_timer_timeout)
	invu_timer.set_one_shot(true) 
	
	# AMMO
	ammoQte = maxAmmo
	
func _process(delta):
	$PointLight2D.energy = 0
	cam.position = position

func _physics_process(delta):
	var direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	if direction.length() > 0:
		direction = direction.normalized() * (DASH_SPEED if is_dashing else SPEED)
		velocity.x = direction.x
		velocity.y = direction.y
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("rotate_body")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		if $AnimationPlayer.is_playing():
			$AnimationPlayer.stop()

	if Input.is_action_just_pressed("dash") and not is_dashing:
		is_dashing = true
		dash_timer.start(DASH_TIME)

	if Input.is_action_just_pressed("attack"):
		fire()
	
	look_at(get_global_mouse_position())
	
	move_and_slide()
	
func _on_dash_timer_timeout():
	is_dashing = false



func fire():
	if ammoQte > 0:
		ammoQte = ammoQte - 1
		updateAmmoUI()
		var bullet = bulletscene.instantiate()
		bullet.position = global_position
		bullet.rotation_degrees = rotation_degrees
		bullet.direction = Vector2.RIGHT.rotated(rotation)
		get_parent().add_child(bullet)
		$PointLight2D.energy = 1000
	else :
		print("plus de mun...")

func refullAmmo():
	ammoQte = maxAmmo
	updateAmmoUI()
	print("refull")
	
func takeDamage(ennemyVelocity: Vector2):
	if not is_invu : 
		#manage invu
		is_invu = true
		invu_timer.start(INVU_TIME)
		
		#manage damage
		var funTimer = get_parent().get_node("FunTimer")
		var timeLeft = funTimer.time_left
		funTimer.stop()
		print(timeLeft)
		var newTime = timeLeft - 4.0
		print(timeLeft)
		if newTime > PlayersInfos.funTimerMaxValue :
			newTime = PlayersInfos.funTimerMaxValue
		print(timeLeft)
		funTimer.start(newTime)
		
		#manage knockback
		#knockback(ennemyVelocity)
		
#func knockback(ennemyVelocity: Vector2):
	#var knockbackDirection = (ennemyVelocity - velocity).normalized() * KNOCKBACK_POWER
	#velocity = knockbackDirection
	#move_and_slide()
	
func getAccesCard():
	get_parent().increase_keypass_found()
	
func updateAmmoUI():
	PlayersInfos.nbAmmo = ammoQte

func destroyPlayer():
	set_process_input(false)
	
func _on_invu_timer_timeout():
	is_invu = false
		
func hasKill():
	#if $AudioStreamPlayer.playing == false:
	$AudioStreamPlayer.play()
