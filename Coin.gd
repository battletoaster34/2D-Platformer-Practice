extends StaticBody2D

var playerpos = 0
signal sendcoin

func _on_character_body_2d_position_changed(position):
	playerpos = position.x

func interaction_interact(interactionComponentParent : Node) -> void:
	sendcoin.emit()
func interaction_can_interact(interactionComponentParent : Node) -> bool:
	return true
