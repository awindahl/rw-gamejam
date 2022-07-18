extends Node2D

var id = "1"
var level = 1
var area
var cooldown
var damage
var speed
var projectiles
var duration
var projectile = preload("res://Scenes/BoulderTossProjectile.tscn")
var toSpawn = 0
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

func _process(delta):
	time += delta
	if (time > 0.1) && toSpawn > 0:
		time = 0
		var projectile_instance = projectile.instance().init(damage, speed, duration, area)
		projectile_instance.position = global_transform.origin
		GameMaster.level.add_child(projectile_instance)
		toSpawn -= 1

func _on_AttackTimer_timeout():
	toSpawn = projectiles

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
