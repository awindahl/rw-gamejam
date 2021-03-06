extends Node2D

onready var projectile

var id = "7"
var level = 1
var attack_speed = 2
var move_speed = 10
#range is a timer for making sure the boomerang dies after a while
var projectile_range = 1
var damage = 10
var player_dir = 0.0
var time_to_live = 2
var number_of_projectiles = 2
var projectile_scale = 1
var spawn = false

func _ready():
	projectile = DataMaster.get_scene("/GaleBoomerangProjectile")
	var weaponData = DataMaster.weapons[id]["levels"][str(level)]
	projectile_scale = weaponData["area"]
	attack_speed = weaponData["cooldown"]
	damage = weaponData["damage"]
	move_speed = weaponData["projectile_speed"]
	number_of_projectiles = weaponData["projectiles"]
	time_to_live = weaponData["duration"]
	$AttackTimer.wait_time = attack_speed
	$AttackTimer.start(attack_speed)
	
func _on_AttackTimer_timeout():
	for i in number_of_projectiles:
		var new_projectile = projectile.instance()
		new_projectile.move_speed = move_speed
		new_projectile.projectile_range = projectile_range
		new_projectile.damage = damage
		new_projectile.time_to_live = time_to_live
		add_child(new_projectile)
		yield(get_tree().create_timer(0.25), "timeout")
	
func level_up():
	level += 1
	var weaponData = DataMaster.weapons[id]["levels"][str(level)]
	projectile_range = weaponData["area"]
	attack_speed = weaponData["cooldown"]
	damage = weaponData["damage"]
	move_speed = weaponData["projectile_speed"]
	number_of_projectiles = weaponData["projectiles"]
	time_to_live = weaponData["duration"]
	$AttackTimer.wait_time = attack_speed
