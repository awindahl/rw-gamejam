extends Node2D

onready var projectile = preload("res://Scenes/GaleBoomerangProjectile.tscn")

var attack_speed = 2
var move_speed = 10
var projectile_range = 1
var damage = 10
var player_dir = 0.0
var time_to_live = 2
var number_of_projectiles = 10
var spawn = false

func _ready():
	$AttackTimer.start(attack_speed)
	


func _on_AttackTimer_timeout():
	for i in number_of_projectiles-1:
		player_dir = get_parent().get_parent().facing.x
		var new_projectile = projectile.instance()
		new_projectile.move_speed = move_speed
		new_projectile.projectile_range = projectile_range
		new_projectile.damage = damage
		new_projectile.player_dir = player_dir
		new_projectile.time_to_live = time_to_live
		add_child(new_projectile)
		yield(get_tree().create_timer(0.25), "timeout")
	


