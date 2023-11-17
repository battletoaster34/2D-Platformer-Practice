extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
var insidesomething

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	insidesomething = true
	


func _on_body_exited(body):
	insidesomething = false
