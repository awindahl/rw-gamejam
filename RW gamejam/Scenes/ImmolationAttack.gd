extends Node2D

var id = "3"
var level = 1
var area
var cooldown
var damage
var speed
var projectiles
var duration
var time = 0

func _ready():
	var weaponData = DataMaster.weapons[id]["levels"][str(level)]
	area = weaponData["area"]
	cooldown = weaponData["cooldown"]
	damage = weaponData["damage"]
	speed = weaponData["projectile_speed"]
	projectiles = weaponData["projectiles"]
	duration = weaponData["duration"]
	$AttackTimer.wait_time = cooldown

#func _process(delta):
#	pass

func _on_AttackTimer_timeout():
	for body in $Area2D.get_overlapping_bodies():
		if body.is_in_group("Enemies"):
			body.damage(damage)

func level_up():
	level += 1
	var weaponData = DataMaster.weapons[id]["levels"][str(level)]
	area = weaponData["area"]
	cooldown = weaponData["cooldown"]
	damage = weaponData["damage"]
	speed = weaponData["projectile_speed"]
	projectiles = weaponData["projectiles"]
	duration = weaponData["duration"]
	$AttackTimer.wait_time = cooldown
