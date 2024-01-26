extends CharacterBody2D

const SPEED = 700.0
const DASH_SPEED = 2000.0
const DASH_TIME = 0.2

var is_dashing = false

var dash_timer = Timer.new()

var bulletscene = preload("res://scenes/gameplay/bullet/bullet.tscn")

func _ready():
	add_child(dash_timer)
	dash_timer.timeout.connect(_on_dash_timer_timeout)
	dash_timer.set_one_shot(true) 

func _physics_process(delta):
	var direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	if direction.length() > 0:
		direction = direction.normalized() * (DASH_SPEED if is_dashing else SPEED)
		velocity.x = direction.x
		velocity.y = direction.y
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

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
	var bullet = bulletscene.instantiate()
	bullet.position = global_position
	bullet.rotation_degrees = rotation_degrees
	bullet.direction = Vector2.RIGHT.rotated(rotation)
	get_parent().add_child(bullet)
