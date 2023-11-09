extends CharacterBody2D


var SPEED = 200.0
var crouching = false
const JUMP_VELOCITY = -350.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.

	if not is_on_floor():
		velocity.y += gravity * delta
		$AnimatedSprite2D.animation = "Jump"
		$AnimatedSprite2D.play()
		
	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_pressed("crouch") and is_on_floor():
		SPEED = 50
		if crouching == false:
			$AnimatedSprite2D.animation = "crouchidlestart"
			$AnimatedSprite2D.play()	
			if velocity.x != 0:
				$AnimatedSprite2D.animation = "crouchsidestart"
				$AnimatedSprite2D.flip_v = false
				$AnimatedSprite2D.flip_h = velocity.x < 0
				$AnimatedSprite2D.play()

		crouching = true
		$Crouchinghitbox.disabled = false
		$Standinghitbox.disabled = true
		
	else:
		crouching = false
		SPEED = 200	
		$Crouchinghitbox.disabled = true
		$Standinghitbox.disabled = false
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	

	move_and_slide()





func _on_abovecheck_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print("POOOOOO")
