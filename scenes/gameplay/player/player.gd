extends CharacterBody2D

const SPEED = 300.0
const DASH_SPEED = 600.0
const DASH_TIME = 0.2

var is_dashing = false

var dash_timer = Timer.new()

var bulletscene = preload("res://scenes/gameplay/bullet/bullet.tscn")

# ammo
const maxAmmo = 12
var ammoQte = 0

func _ready():
	add_child(dash_timer)
	dash_timer.timeout.connect(_on_dash_timer_timeout)
	dash_timer.set_one_shot(true) 
	ammoQte = maxAmmo

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
	else :
		print("plus de mun...")

func refullAmmo():
	ammoQte = maxAmmo
	updateAmmoUI()
	print("refull")
	
func updateAmmoUI():
	PlayersInfos.nbAmmo = ammoQte

func destroyPlayer():
	set_process_input(false)
