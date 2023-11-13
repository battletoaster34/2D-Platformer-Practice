extends CharacterBody2D


const SPEED = 200.0
const ACCELERATION = 800.0
const FRICTION = 1000.0
const JUMP_VELOCITY = -350.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var coyote_jump_timer = $CoyoteJumpTimer # gives acces to timer


func _physics_process(delta):
	
	_apply_gravity(delta)
	
	_handle_jump()
	
	var input_axis = Input.get_axis("left", "right")
	
	_handle_acceleration(input_axis, delta)
	
	_apply_friction(input_axis, delta)

	move_and_slide()

func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
func _handle_jump():
	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = JUMP_VELOCITY
	#makes a short jump if the jump button is pressed for a short time
		else:
			if Input.is_action_just_released("ui_accept") and velocity.y < JUMP_VELOCITY / 2:
				velocity.y = JUMP_VELOCITY / 2
				
func _apply_friction(input_axis, delta):
	if input_axis == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		
func _handle_acceleration(input_axis, delta):
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, SPEED * input_axis, ACCELERATION * delta)
