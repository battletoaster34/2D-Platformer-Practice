extends Area2D

@export var interaction_parent : NodePath
signal on_interactible_changed(newInteractible)
var interaction_target : Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (interaction_target != null and Input.is_action_just_pressed("interact")):
		if (interaction_target.has_method("interaction_interact")):
			interaction_target.interaction_interact(self)

var poo

func removeselffromarray(arrayc):
		if len(arrayc) > 1:
			for x in arrayc:
				if "CharacterBody2D" in str(x):
					arrayc.erase(x)
		else:
			if "CharacterBody2D" in str(arrayc):
				arrayc.erase(arrayc[0])


func _on_body_entered(body):	
	var caninteract = false
	
	if (body.has_method("interaction_can_interact")):
		caninteract = body.interaction_can_interact(get_node(interaction_parent))
		print(caninteract)
	if not caninteract:
		return
	interaction_target = body
	emit_signal("on_interactible_changed", interaction_target)



func _on_body_exited(body):
	if body == interaction_target:
		interaction_target = null
		emit_signal("on_interactible_changed", interaction_target)
		
