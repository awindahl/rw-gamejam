extends Area2D

var has_player = false
var Player = null
var speed = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if has_player:
		position.x = lerp(position.x, Player.position.x, delta*speed)
		position.y = lerp(position.y, Player.position.y, delta*speed)
	else:
		pass


func _on_Pickup_body_entered(body):
	if body.is_in_group("Player"):
		body.xp += 1
		queue_free()
