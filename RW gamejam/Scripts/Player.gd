extends KinematicBody2D

var up
var down
var left
var right
var select
var cancel

var move_speed = 250
var acceleration = 0.5

var direction = Vector2()
var velocity = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	up = Input.is_action_pressed("ui_up")
	down = Input.is_action_pressed("ui_down")
	left = Input.is_action_pressed("ui_left")
	right = Input.is_action_pressed("ui_right")
	
	select = Input.is_action_just_pressed("ui_accept")
	cancel = Input.is_action_just_pressed("ui_cancel")
	
	
	#is moving
	if up or down or left or right:
		if up:
			direction.y = -1
		elif down:
			direction.y = 1
		else:
			direction.y = 0
		if left:
			direction.x = -1
		elif right:
			direction.x = 1
		else:
			direction.x = 0
		
	#smoothly decelerate
	elif not (up and down and left and right):
		direction *= 0
	
	
	velocity.x = lerp(velocity.x, direction.x, acceleration)
	velocity.y = lerp(velocity.y, direction.y, acceleration)
	
	print(velocity)

	
	move_and_slide(velocity * move_speed)

