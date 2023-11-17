extends CharacterBody2D

var insidesomething = false
var SPEED = 150.0
var crouching = false
var sprinting = false
const JUMP_VELOCITY = -350.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.

	if Input.is_action_just_pressed("Reset"):
		position.x = 0
		position.y = 0
	
	if not is_on_floor():
		velocity.y += gravity * delta
		$AnimatedSprite2D.animation = "Jump"
		$AnimatedSprite2D.play()

	# Handle Jump.
	if insidesomething == false:
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		
	#CROUCHING	
	if Input.is_action_pressed("crouch") and is_on_floor():
		SPEED = 50
		if crouching == false:
			$AnimatedSprite2D.animation = "crouchidlestart"
			$AnimatedSprite2D.play()	
			
			abovesensorlist = $Area2D2.get_overlapping_bodies()
			removeselffromarray(abovesensorlist)
			if self not in abovesensorlist and len(abovesensorlist) != 0:
				insidesomething = true
				
			if velocity.x != 0:
				$AnimatedSprite2D.animation = "crouchsidestart"
				$AnimatedSprite2D.flip_v = false
				$AnimatedSprite2D.flip_h = velocity.x < 0
				$AnimatedSprite2D.play()

		crouching = true
		
		$Crouchinghitbox.disabled = false
		$Standinghitbox.disabled = true
		
	else:
		if insidesomething == false:
			crouching = false
			SPEED = 150	
			$Crouchinghitbox.disabled = true
			$Standinghitbox.disabled = false
		
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

			
		
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	

	move_and_slide()



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
	
	abovesensorlist2 = $Area2D2.get_overlapping_bodies()
	removeselffromarray(abovesensorlist2)
	if self not in abovesensorlist2 and abovesensorlist2 != abovesensorlist:
		insidesomething = false
