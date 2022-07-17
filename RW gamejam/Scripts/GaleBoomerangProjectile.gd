extends Node2D

onready var distance_timer = $DistanceTimer
onready var hitbox = $Area2D/CollisionShape2D
onready var death_timer = $DeathTimer

var has_turned = false
var move_speed 
var projectile_range 
var damage
var player_dir
var time_to_live

func _ready():
	distance_timer.start(projectile_range)
	set_as_toplevel(true)
	global_position = get_parent().global_position
	death_timer.start(time_to_live)
	if player_dir < 0:
		move_speed *= -1

func _process(delta):
	if not has_turned:
		position.x += move_speed
	elif has_turned:
		position.x -= move_speed
		


func _on_DistanceTimer_timeout():
	if not has_turned:
		has_turned = true


func _on_Area2D_body_entered(body):
	if body.is_in_group("Enemies"):
		body.damage(damage)


func _on_AttackCooldown_timeout():
	hitbox.disabled *= -1


func _on_DeathTimer_timeout():
	queue_free()
