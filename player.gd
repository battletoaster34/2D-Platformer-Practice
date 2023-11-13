extends CharacterBody2D


const SPEED = 200.0
const ACCELERATION = 800.0
const FRICTION = 1000.0
const JUMP_VELOCITY = -350.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var cyotejump_timer = $cyotejumpTimer


func _physics_process(delta):
	
	_apply_gravity(delta)
	
	_handle_jump()
	
	var input_axis = Input.get_axis("left", "right")
	
	_handle_acceleration(input_axis, delta)
	
	_apply_friction(input_axis, delta)

	var was_on_floor = is_on_floor() # is it on floor before character moves
	
	move_and_slide()
	
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y <=0 # if on floor before but not after you on ledge(if going up no jumpies for you)
	if just_left_ledge:            # starts timer if left ledge
		cyotejump_timer.start()

func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
func _handle_jump():
	if is_on_floor() or cyotejump_timer.time_left >0.0: # can also jump if timer is on
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = JUMP_VELOCITY
	#makes a short jump if the jump button is pressed for a short time
		if not is_on_floor(): # fixes the break our new if statement makes
			if Input.is_action_just_released("ui_accept") and velocity.y < JUMP_VELOCITY / 2:
				velocity.y = JUMP_VELOCITY / 2
				
func _apply_friction(input_axis, delta):
	if input_axis == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		
func _handle_acceleration(input_axis, delta):
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, SPEED * input_axis, ACCELERATION * delta)
