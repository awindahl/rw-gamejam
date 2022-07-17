extends KinematicBody2D

#node gets
onready var aoe_hitbox = $Hitbox
onready var aoe_hitbox_size = $Hitbox/CollisionShape2D
onready var attack_particles = $Hitbox/CPUParticles2D
onready var weapons = $Weapons
onready var UI = $CanvasLayer/UI
onready var LevelUp = $LevelUpLayer/LevelUp  
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
var nextLevel = 50
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
var weapon_max_slots = 4
var item_max_slots = 4

#player movement
var move_speed = 250
var acceleration = 0.5
var direction = Vector2()
var velocity = Vector2()
var is_hit = false
var hit_dir = Vector2()
var facing = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	current_hp = max_hp
	_update_ring()
	_weapon_update()
	UI_update()

# Called when pickup area size is changed.
func _update_ring():
	#attack_particles.emission_sphere_radius = aoe_size
	aoe_hitbox_size.shape.radius = aoe_size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (xp >= nextLevel):
		UI_update()
		#check if we can level up again after our previous level up
	#checks every frame which keys are down
	up = Input.is_action_pressed("ui_up")
	down = Input.is_action_pressed("ui_down")
	left = Input.is_action_pressed("ui_left")
	right = Input.is_action_pressed("ui_right")
	select = Input.is_action_just_pressed("ui_accept")
	cancel = Input.is_action_just_pressed("ui_cancel")
	
	if velocity.x < 0:
		facing.x = -1
		weapons.scale.x = -1
		if sprite.flip_h != true:
			sprite.flip_h = true
		
	if velocity.x > 0:
		facing.x = 1
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

func give_weapon(weapon): call_deferred("give_weapon_deferred", weapon)
func give_weapon_deferred(weapon_id):
	var hasWeapon = false
	for weapon in weapons.get_children():
		if (weapon.id == weapon_id && weapon.level < DataMaster.weapons[str(weapon_id)]["maxLevel"]):
			print("leveling up weapon! found a weapon equipped that is not max level")
			weapon.level_up();
			hasWeapon = true
			break
		elif (weapon.id == weapon_id):
			print("found a max leveled weapon")
			hasWeapon = true
			break
	if !hasWeapon && weapon_max_slots > weapons.get_child_count():
		print("found a new shiny weapon! and we have extra slots!")
		weapons.add_child(load("res://Scenes/"+DataMaster.weapons[str(weapon_id)]["scene"]+".tscn").instance())
	_weapon_update()

func _weapon_update():
	weapon_label.text = "Current weapons: \n"
	for weapon in weapons.get_children():
		weapon_label.text += "\n"
		weapon_label.text += DataMaster.weapons[weapon.id]["name"]

func get_weapon_level(weapon_id):
	for _weapon in weapons.get_children():
		if _weapon.id == weapon_id: 
			return _weapon.level
	return 0

func get_player_weapons():
	return weapons.get_children()

func get_item_level(item_id):
	return 1

func get_player_items():
#	return items.get_children()
	pass

func UI_update():
	if (xp >= nextLevel):
		XP_bar.min_value = nextLevel
		nextLevel = int(nextLevel + pow(nextLevel,0.8))
		XP_bar.max_value = nextLevel
		level_up()
	XP_bar.value = xp
	HP_bar.value = current_hp
	HP_bar.max_value = max_hp
	
func level_up():
	LevelUp.visible = true
	LevelUp.level_up()
	get_tree().paused = true

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
	UI_update()

func _on_HitTimer_timeout():
	is_hit = false

func _on_InvincibilityTimer_timeout():
	is_invincible = false
	sprite.modulate.a = 1

func change_clothes(type):
	var clothes = load("res://Assets/"+type+".png")
	sprite.texture = clothes
