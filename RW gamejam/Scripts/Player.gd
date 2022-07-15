extends KinematicBody2D

#node gets
onready var aoe_hitbox = $Hitbox
onready var aoe_hitbox_size = $Hitbox/CollisionShape2D
onready var attack_particles = $Hitbox/CPUParticles2D
onready var weapons = $Weapons

#input
var up
var down
var left
var right
var select 
var cancel

#how big the area around the player is for picking up items
var aoe_size = 80

#player movement
var move_speed = 250
var acceleration = 0.5
var direction = Vector2()
var velocity = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	_update_ring()

# Called when pickup area size is changed.
func _update_ring():
	#attack_particles.emission_sphere_radius = aoe_size
	aoe_hitbox_size.shape.radius = aoe_size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#checks every frame which keys are down
	up = Input.is_action_pressed("ui_up")
	down = Input.is_action_pressed("ui_down")
	left = Input.is_action_pressed("ui_left")
	right = Input.is_action_pressed("ui_right")
	select = Input.is_action_just_pressed("ui_accept")
	cancel = Input.is_action_just_pressed("ui_cancel")
	
	if Input.is_action_just_pressed("ui_left"):
		weapons.scale.x = -1
		
	if Input.is_action_just_pressed("ui_right"):
		weapons.scale.x = 1
	
	print(scale.x)
	#movement direction handler
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
	
	#smoothly accelerate
	velocity.x = lerp(velocity.x, direction.x, acceleration)
	velocity.y = lerp(velocity.y, direction.y, acceleration)
	
	move_and_slide(velocity * move_speed)
	


func _on_Hitbox_area_entered(area):
	if area.is_in_group("Pickups"):
		if not area.has_player:
			area.has_player = true
			area.Player = self
