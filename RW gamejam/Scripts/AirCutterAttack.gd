extends Node2D

onready var projectile
onready var attack_timer = $AttackTimer

var id = "6"
var level = 1
var speed
var projectiles
var duration
var damage
var attack_speed
var current_air_particle_effect = null
var hitbox_size
var number_of_projectiles
var player_dir

func _ready():
	projectile = DataMaster.get_scene("/AirCutterProjectile")
	var weaponData = DataMaster.weapons[id]["levels"][str(level)]
	hitbox_size = weaponData["area"]
	attack_speed = weaponData["cooldown"]
	damage = weaponData["damage"]
	speed = weaponData["projectile_speed"]
	number_of_projectiles = weaponData["projectiles"]
	duration = weaponData["duration"]
	attack_timer.start(attack_speed)


func _on_AttackTimer_timeout():
	for i in number_of_projectiles:
		var new_projectile = projectile.instance()
		new_projectile.damage = damage
		new_projectile.time_to_live = duration
		new_projectile.hitbox = hitbox_size
		new_projectile.set_as_toplevel(true)
		new_projectile.global_position = global_position
		add_child(new_projectile)
		yield(get_tree().create_timer(0.5), "timeout")


func level_up():
	level += 1
	var weaponData = DataMaster.weapons[id]["levels"][str(level)]
	hitbox_size = weaponData["area"]
	attack_speed = weaponData["cooldown"]
	damage = weaponData["damage"]
	speed = weaponData["projectile_speed"]
	projectiles = weaponData["projectiles"]
	duration = weaponData["duration"]
	attack_timer.wait_time = attack_speed
