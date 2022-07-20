extends Node2D


onready var hitbox = $Area2D/CollisionShape2D
onready var death_timer = $DeathTimer

var damage
var time_to_live
var player_dir = 0.0


func _ready():
	death_timer.start(time_to_live)
	player_dir = get_parent().get_parent().get_parent().facing.x
	if player_dir < 0:
		rotation_degrees = 180
	$AirCutter.angle = rotation_degrees
	$AirCutter.scale_amount = scale.x * 2.2 
	
	print(hitbox.get_parent().rotation_degrees)
	

func _on_AttackTimer_timeout():
	hitbox.disabled = true


func _on_AttackCooldown_timeout():
	$AirCutter.emitting = false


func _on_DeathTimer_timeout():
	queue_free()
	

func _on_Area2D_body_entered(body):
	if body.is_in_group("Enemies"):
		body.damage(damage)
