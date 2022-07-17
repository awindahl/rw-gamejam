extends Node2D

var area
var cooldown
var damage = 1
var speed = 20
var duration
var level = 1
var projectile = preload("res://Scenes/WaterMissileProjectile.tscn")

func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_AttackTimer_timeout():	
	var projectile_instance = projectile.instance().init(damage, speed)
	projectile_instance.position = global_transform.origin
	GameMaster.level.add_child(projectile_instance)
