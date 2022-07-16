extends Node2D

onready var air_particle_effect = preload("res://Scenes/ParticlePlayground.tscn")
onready var attack_timer = $AttackTimer
onready var particle_timer = $ParticleTimer
onready var attack_cooldown = $AttackCooldown
onready var hitbox = $Area2D/CollisionShape2D

var damage = 10
var attack_speed = 0.3
var current_air_particle_effect = null
var hitbox_size = 100

func _ready():
	attack_timer.start(attack_speed)
	hitbox.shape.radius = 100


func _on_Area2D_body_entered(body):
	if body.is_in_group("Enemies"):
		body.damage(damage)


func _on_AttackTimer_timeout():
	hitbox.disabled = false
	
	var new_air_particle = air_particle_effect.instance()
	new_air_particle.get_node("AirCutter").visible = true
	new_air_particle.get_node("AirCutter").emitting = true
	add_child(new_air_particle)
	current_air_particle_effect = new_air_particle
	particle_timer.start()
	attack_cooldown.start()


func _on_AttackCooldown_timeout():
	hitbox.disabled = true


func _on_ParticleTimer_timeout():
	current_air_particle_effect.get_node("AirCutter").emitting = false
	#current_air_particle_effect.queue_free()
