extends Node2D

onready var fire_particle_effect = $Fire
onready var attack_timer = $AttackTimer
onready var particle_timer = $ParticleTimer
onready var attack_cooldown = $AttackCooldown
onready var hitbox = $Area2D/CollisionPolygon2D

var id = "2"
var level = 1
var attack_speed = 0.5
var damage = 3
var area
var speed
var projectiles
var duration

# Called when the node enters the scene tree for the first time.
func _ready():
	var weaponData = DataMaster.weapons[id]["levels"][str(level)]
	area = weaponData["area"]
	attack_speed = weaponData["cooldown"]
	damage = weaponData["damage"]
	speed = weaponData["projectile_speed"]
	projectiles = weaponData["projectiles"]
	duration = weaponData["duration"]
	attack_timer.wait_time = attack_speed
	_update()


func _process(delta):
	if get_parent().get_parent().facing.x < 0:
		scale.x = -1
		fire_particle_effect.angle = 180
	else:
		scale.x = 1
		fire_particle_effect.angle = 0

func _update():
	scale.x = area
	scale.y = area
	

func _on_AttackTimer_timeout():
	hitbox.disabled = false
	attack_cooldown.start()
	attack_timer.wait_time = attack_speed


func _on_AttackCooldown_timeout():
	hitbox.disabled = true


func _on_Area2D_body_entered(body):
	if body.is_in_group("Enemies"):
		body.damage(damage)

func level_up():
	level += 1
	var weaponData = DataMaster.weapons[id]["levels"][str(level)]
	area = weaponData["area"]
	attack_speed = weaponData["cooldown"]
	damage = weaponData["damage"]
	speed = weaponData["projectile_speed"]
	projectiles = weaponData["projectiles"]
	duration = weaponData["duration"]
	attack_timer.wait_time = attack_speed
	_update()
