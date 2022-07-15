extends Node2D

onready var particles = preload("../Scenes/HitParticle.tscn")
onready var spawn_point = $ParticleSpawn
onready var anim_player = $AnimationPlayer
onready var area = $Area2D

var attack_speed = 1
var damage = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _particles():
	var new_particles = particles.instance()
	new_particles.emitting = true
	add_child(new_particles)
	new_particles.position = spawn_point.position


func _on_Timer_timeout():
	anim_player.play("Whip")


func _on_Area2D_body_entered(body):
	if body.is_in_group("Enemies"):
			body.damage(damage)
