extends KinematicBody2D

#node gets
onready var aoe_hitbox = $Hitbox
onready var aoe_hitbox_size = $Hitbox/CollisionShape2D
onready var attack_particles = $Hitbox/CPUParticles2D
onready var weapons = $Weapons
onready var UI = $CanvasLayer/UI
onready var XP_bar = $CanvasLayer/UI/XPbar
onready var HP_bar = $HPbar
onready var blood_particles = preload("res://Scenes/BloodParticles.tscn")
onready var hit_timer = $HitTimer
onready var invic_timer = $InvincibilityTimer
onready var sprite = $Sprite
onready var weapon_label = $CanvasLayer/UI/WeaponsLabel
onready var animator = $AnimationPlayer

#xp, hp, etc
var xp = 0
var max_hp = 100
var current_hp = 100
var is_invincible = false

#input
var up
var down
var left
var right
var select 
var cancel

#how big the area around the player is for picking up items
var aoe_size = 80

#weapons array
var current_weapon_array = []

#player movement
var move_speed = 250
var acceleration = 0.5
var direction = Vector2()
var velocity = Vector2()
var is_hit = false
var hit_dir = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	current_hp = max_hp
	_update_ring()
	weapon_update()

# Called when pickup area size is changed.
func _update_ring():
	#attack_particles.emission_sphere_radius = aoe_size
	aoe_hitbox_size.shape.radius = aoe_size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	UI_update()
	
	#checks every frame which keys are down
	up = Input.is_action_pressed("ui_up")
	down = Input.is_action_pressed("ui_down")
	left = Input.is_action_pressed("ui_left")
	right = Input.is_action_pressed("ui_right")
	select = Input.is_action_just_pressed("ui_accept")
	cancel = Input.is_action_just_pressed("ui_cancel")
	
	if Input.is_action_just_pressed("ui_left"):
		weapons.scale.x = -1
		if sprite.flip_h != true:
			sprite.flip_h = true
		
	if Input.is_action_just_pressed("ui_right"):
		weapons.scale.x = 1
		if sprite.flip_h == true:
			sprite.flip_h = false
	
	#movement direction handler
	if up or down or left or right:
		animator.play("walk")
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
		animator.stop(false)
		direction *= 0
	
	#smoothly accelerate
	velocity.x = lerp(velocity.x, direction.x, acceleration)
	velocity.y = lerp(velocity.y, direction.y, acceleration)
	
	if not is_hit:
		var _m = move_and_slide(velocity * move_speed)
	elif is_hit:
		var _m = move_and_slide(hit_dir * 20)


func weapon_update():
	weapon_label.text += "\n"
	
	for weapon in weapons.get_children():
		weapon_label.text += "\n"
		weapon_label.text += weapon.name

func UI_update():
	XP_bar.value = xp
	HP_bar.value = current_hp
	HP_bar.max_value = max_hp
	

func _on_Hitbox_area_entered(area):
	if area.is_in_group("Pickups"):
		if not area.has_player:
			area.has_player = true
			area.Player = self

func damage(damage):
	var new_blood = blood_particles.instance()
	add_child(new_blood)
	new_blood.emitting = true
	current_hp -= damage
	hit_timer.start()
	invic_timer.start()
	is_invincible = true
	sprite.modulate.a = 0.5

func _on_HitTimer_timeout():
	is_hit = false

func _on_InvincibilityTimer_timeout():
	is_invincible = false
	sprite.modulate.a = 1

func change_clothes(type):
	var clothes = load("res://Assets/"+type+".png")
	sprite.texture = clothes
