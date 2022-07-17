extends Node2D

onready var fire_particle_effect = preload("res://Scenes/ParticlePlayground.tscn")
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
	attack_timer.start(attack_speed)
	var new_fire = fire_particle_effect.instance()
	new_fire.get_node("Fire").visible = true
	new_fire.get_node("Fire").emitting = true
	add_child(new_fire)


func _on_AttackTimer_timeout():
	hitbox.disabled = false
	attack_cooldown.start()


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
