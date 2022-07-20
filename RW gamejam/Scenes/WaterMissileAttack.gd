extends Node2D

var id = "5"
var level = 1
var area
var cooldown
var damage
var speed
var projectiles
var duration
var projectile
var toSpawn = 0
var time = 0

func _ready():
	projectile = DataMaster.get_scene("/WaterMissileProjectile")
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
		var projectile_instance = projectile.instance().init(damage, speed)
		projectile_instance.position = global_transform.origin+Vector2(rand_range (-20, 20), rand_range (-20, 20))
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
