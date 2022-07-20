extends Node2D

onready var ground_particle_effect = $QuakeParticle
onready var attack_timer = $AttackTimer
onready var hitbox = $Area2D/CollisionShape2D
onready var disable_timer = $AttackActive
onready var start_timer = $AttackStart

var id = "0"
var level = 1
var speed
var projectiles
var duration
var attack_speed = 0.5
var hitbox_size = 127
var damage = 5

func _ready():
	var weaponData = DataMaster.weapons[id]["levels"][str(level)]
	hitbox_size = weaponData["area"]
	attack_speed = weaponData["cooldown"]
	damage = weaponData["damage"]
	speed = weaponData["projectile_speed"]
	projectiles = weaponData["projectiles"]
	duration = weaponData["duration"]
	attack_timer.wait_time = attack_speed
	attack_timer.start(attack_speed)
	hitbox.shape.radius = hitbox_size

# Called on attacks
func attack():
	ground_particle_effect.scale_amount = (hitbox_size/100 * 3.32)
	ground_particle_effect.emitting = true
	hitbox.disabled = false
	disable_timer.start()


func _on_AttackTimer_timeout():
	attack_timer.start(attack_speed)
	start_timer.start()



func _on_Area2D_body_entered(body):
	if body.is_in_group("Enemies"):
		body.damage(damage)


func _on_AttackActive_timeout():
	hitbox.disabled = true
	ground_particle_effect.one_shot = false
	ground_particle_effect.emitting = false


func _on_AttackStart_timeout():
	attack()


func level_up():
	level += 1
	var weaponData = DataMaster.weapons[id]["levels"][str(level)]
	hitbox_size = weaponData["area"]
	attack_speed = weaponData["cooldown"]
	damage = weaponData["damage"]
	speed = weaponData["projectile_speed"]
	projectiles = weaponData["projectiles"]
	duration = weaponData["duration"]
	attack_timer.wait_time = attack_speed
	hitbox.shape.radius = hitbox_size
