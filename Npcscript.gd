extends StaticBody2D

var playerpos = 0



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_faceplayer()
func _faceplayer():
	if playerpos > position.x:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false


func _on_character_body_2d_position_changed(position):
	playerpos = position.x

func interaction_interact(interactionComponentParent : Node) -> void:
	$AnimatedSprite2D.play()
func interaction_can_interact(interactionComponentParent : Node) -> bool:
	return true
