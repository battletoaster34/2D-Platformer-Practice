extends CharacterBody2D


const SPEED = 200.0
const ACCELERATION = 800.0
const FRICTION = 1000.0
var insidesomething = false
var crouching = false
const JUMP_VELOCITY = -350.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var coyote_jump_timer = $CoyoteJumpTimer # gives acces to timer


func _physics_process(delta):
	# Add the gravity.

	_apply_gravity(delta)

	
	_handle_jump()

	var input_axis = Input.get_axis("left", "right")
		
	_handle_acceleration(input_axis, delta)
		
	_apply_friction(input_axis, delta)

	_handle_crouch(input_axis, delta)
	_handle_animation(input_axis, delta)

	move_and_slide()
		
			
		
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
func _handle_jump():
	if insidesomething == false:
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = JUMP_VELOCITY
			#makes a short jump if the jump button is pressed for a short time

	else:
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = JUMP_VELOCITY
	#makes a short jump if the jump button is pressed for a short time

func _handle_crouch():
	if Input.is_action_pressed("crouch") and is_on_floor():
		SPEED = 50
		if crouching == false:
			$AnimatedSprite2D.animation = "crouchidlestart"
			$AnimatedSprite2D.play()	
			
			abovesensorlist = $Area2D2.get_overlapping_bodies()
			removeselffromarray(abovesensorlist)
			if self not in abovesensorlist and len(abovesensorlist) != 0:
				insidesomething = true
		
		crouching = true
		$Crouchinghitbox.disabled = false
		$Standinghitbox.disabled = true
		
	else:
		if insidesomething == false:
			crouching = false
			SPEED = 200	
			$Crouchinghitbox.disabled = true
			$Standinghitbox.disabled = false

func _handle_animation():
	if is_on_floor():
		if velocity.x != 0:
			if crouching == false:
				$AnimatedSprite2D.animation = "right"
				$AnimatedSprite2D.flip_v = false
				$AnimatedSprite2D.flip_h = velocity.x < 0
				$AnimatedSprite2D.play()
			else:
				if ($AnimatedSprite2D.animation == "crouchsidestart" and $AnimatedSprite2D.is_playing() == false) or $AnimatedSprite2D.animation != "crouchsidestart":
					$AnimatedSprite2D.animation = "sidecrouchmove"
					$AnimatedSprite2D.flip_v = false
					$AnimatedSprite2D.flip_h = velocity.x < 0
					$AnimatedSprite2D.play()
		elif crouching == false:
			$AnimatedSprite2D.animation = "idle"
			$AnimatedSprite2D.play()
		else:
			if ($AnimatedSprite2D.animation == "crouchidlestart" and $AnimatedSprite2D.is_playing() == false) or $AnimatedSprite2D.animation != "crouchidlestart":
				$AnimatedSprite2D.animation = "crouchidle"
				$AnimatedSprite2D.play()	
	



func removeselffromarray(arrayc):
		if len(arrayc) > 1:
			for x in arrayc:
				if str(self) in str(x):
					arrayc.erase(x)
		else:
			if self in arrayc:
				arrayc.erase(arrayc[0])


var abovesensorlist
var abovesensorlist2

func _on_area_2d_2_body_entered(body):
	abovesensorlist = $Area2D2.get_overlapping_bodies()
	removeselffromarray(abovesensorlist)
	if self not in abovesensorlist and len(abovesensorlist) != 0 and crouching:
		insidesomething = true



func _on_area_2d_2_body_exited(body):
func _apply_friction(input_axis, delta):
	if input_axis == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	
	abovesensorlist2 = $Area2D2.get_overlapping_bodies()
	removeselffromarray(abovesensorlist2)
	if self not in abovesensorlist2 and abovesensorlist2 != abovesensorlist:
		insidesomething = false
func _handle_acceleration(input_axis, delta):
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, SPEED * input_axis, ACCELERATION * delta)
