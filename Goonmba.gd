extends CharacterBody2D

var speed = -60

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var facing_right = false


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if !$RayCast2DL.is_colliding() && is_on_floor():
		flip()
	
	if !$RayCast2DR.is_colliding() && is_on_floor():
		flip()
	
	velocity.x = speed
	move_and_slide()

func flip():
	facing_right = !facing_right
	
	if facing_right:
		speed = abs(speed)
	
	else:
		speed = abs(speed) * -1

func _reset():
	if Input.is_action_pressed("Reset"):
		position.x=0
		position.y=0
