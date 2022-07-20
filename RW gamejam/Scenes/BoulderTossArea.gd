extends Node2D

onready var ground_particle_effect
onready var particle_timer = $ParticleTimer
onready var area2d = $Area2D  

var radius
var damage
var damaged = false
var time = 0

func init(dmg, area):
	damage = dmg
	radius = area
	return self

func _ready():
	ground_particle_effect = DataMaster.get_scene("ParticlePlayground")
	scale = Vector2(radius, radius)
	var new_ground_particle = ground_particle_effect.instance()
	new_ground_particle.get_node("GroundPound").visible = true
	new_ground_particle.scale *= 0.5
	add_child(new_ground_particle)
	particle_timer.start()

func _process(delta):
	time += delta
	if time > 0.1 && !damaged:
		for body in area2d.get_overlapping_bodies():
			if body.is_in_group("Enemies") && !damaged:
				body.damage(damage)
		damaged = true

func _on_ParticleTimer_timeout():
	queue_free()
