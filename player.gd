extends CharacterBody2D


var SPEED = 150.0
const ACCELERATION = 800.0
const FRICTION = 800.0
var insidesomething = false
var crouching = false
var sprinting = false
const JUMP_VELOCITY = -350.0

var coins = 0
var lives = 3


signal position_changed(position)


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

	_handle_crouch()
	_handle_sprint()
	_handle_animation()
	
	_reset()
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >=0
	if just_left_ledge:
		coyote_jump_timer.start()
	
	emit_signal("position_changed", self.global_position)
		
		
func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		$AnimatedSprite2D.animation = "Jump"
		$AnimatedSprite2D.play()
	# Get the input direction and handle the movement/deceleration.
func _handle_jump():
	if is_on_floor() or coyote_jump_timer.time_left >0.0:
		if insidesomething == false:
			if Input.is_action_just_pressed("Jump"):
				velocity.y = JUMP_VELOCITY
				#makes a short jump if the jump button is pressed for a short time

		if not is_on_floor():
			if Input.is_action_just_pressed("Jump"):
				velocity.y = JUMP_VELOCITY
	#makes a short jump if the jump button is pressed for a short time

func _handle_crouch():
	if sprinting == false:
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
				SPEED = 150	
				$Crouchinghitbox.disabled = true
				$Standinghitbox.disabled = false
func _handle_sprint():
	if crouching == false:
		if Input.is_action_pressed("Sprint"):
			SPEED = 200
			if sprinting == false:
				$AnimatedSprite2D.animation = "Sprint"
				$AnimatedSprite2D.flip_v = false
				$AnimatedSprite2D.flip_h = velocity.x < 0
				$AnimatedSprite2D.play()
			sprinting = true
		else:
			sprinting = false
			if crouching == false:
				SPEED = 150
func _handle_animation():
	if is_on_floor():
		if velocity.x != 0:
			if crouching == false and sprinting == false:
				$AnimatedSprite2D.animation = "right"
				$AnimatedSprite2D.flip_v = false
				$AnimatedSprite2D.flip_h = velocity.x < 0
				$AnimatedSprite2D.play()
			elif crouching:
				if ($AnimatedSprite2D.animation == "crouchsidestart" and $AnimatedSprite2D.is_playing() == false) or $AnimatedSprite2D.animation != "crouchsidestart":
					$AnimatedSprite2D.animation = "sidecrouchmove"
					$AnimatedSprite2D.flip_v = false
					$AnimatedSprite2D.flip_h = velocity.x < 0
					$AnimatedSprite2D.play()
			elif sprinting:
				$AnimatedSprite2D.animation = "Sprint"
				$AnimatedSprite2D.flip_v = false
				$AnimatedSprite2D.flip_h = velocity.x < 0
				$AnimatedSprite2D.play()
		elif crouching == false and sprinting == false:
			$AnimatedSprite2D.animation = "idle"
			$AnimatedSprite2D.play()
		elif sprinting:
			$AnimatedSprite2D.animation = "sprintidle"
			$AnimatedSprite2D.play()			
		elif crouching:
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
				
func _reset():
	if Input.is_action_pressed("Reset"):
		position.x=0
		position.y=0
		

var abovesensorlist
var abovesensorlist2

func _on_area_2d_2_body_entered(body):
	abovesensorlist = $Area2D2.get_overlapping_bodies()
	removeselffromarray(abovesensorlist)
	if self not in abovesensorlist and len(abovesensorlist) != 0 and crouching:
		insidesomething = true



func _on_area_2d_2_body_exited(body):
	abovesensorlist = $Area2D2.get_overlapping_bodies()
	removeselffromarray(abovesensorlist)
	if self not in abovesensorlist2 and abovesensorlist2 != abovesensorlist:
		insidesomething = false
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
		
var interactiblesinrange
func _interactionradiusfunctioning():
	pass
		



func _on_interaction_radius_body_entered(body):
	interactiblesinrange = $InteractionRadius.get_overlapping_bodies()
	removeselffromarray(interactiblesinrange)
	if len(interactiblesinrange) > 1:
		for x in interactiblesinrange:
			if str("TileMapLevel1") in str(x):
				interactiblesinrange.erase(x)
	else:
		if "TileMapLevel1" in str(interactiblesinrange):
			interactiblesinrange.erase(interactiblesinrange[0])
	#

	


func _on_interaction_radius_body_exited(body):
	pass # Replace with function body.


func _on_coin_sendcoin():
	coins+=1
	if coins == 100:
		lives+=1
		coins = 0
