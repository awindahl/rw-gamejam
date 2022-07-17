extends Node2D

var area
var cooldown
var damage
var speed
var projectiles
var duration
var level = 1
var projectile = preload("res://Scenes/WaterMissileProjectile.tscn")
var toSpawn = 0
var time = 0

func _ready():
	area = DataMaster.weapons["5"]["area"]
	cooldown = DataMaster.weapons["5"]["cooldown"]
	damage = DataMaster.weapons["5"]["damage"]
	speed = DataMaster.weapons["5"]["projectile_speed"]
	projectiles = DataMaster.weapons["5"]["projectiles"]
	duration = DataMaster.weapons["5"]["duration"]

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
