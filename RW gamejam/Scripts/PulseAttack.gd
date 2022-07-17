extends Node2D

onready var ground_particle_effect = preload("res://Scenes/ParticlePlayground.tscn")
onready var attack_timer = $AttackTimer
onready var particle_timer = $ParticleTimer
onready var hitbox = $Area2D/CollisionShape2D
onready var disable_timer = $AttackActive
onready var start_timer = $AttackStart

var id = "0"
var level = 1
var speed
var projectiles
var duration
var attack_speed = 0.5
var current_ground_particle = null
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
	hitbox.disabled = false
	disable_timer.start()


func _on_AttackTimer_timeout():
	attack_timer.start(attack_speed)
	var new_ground_particle = ground_particle_effect.instance()
	new_ground_particle.get_node("GroundPound").visible = true
	new_ground_particle.scale *= 0.5
	add_child(new_ground_particle)
	current_ground_particle = new_ground_particle
	particle_timer.start()
	start_timer.start()


func _on_ParticleTimer_timeout():
	current_ground_particle.queue_free()


func _on_Area2D_body_entered(body):
	if body.is_in_group("Enemies"):
		body.damage(damage)

func _on_AttackActive_timeout():
	hitbox.disabled = true


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
