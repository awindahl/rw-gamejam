extends Node2D

var damage = 0
var speed = 0
var lockedOn
var dying = false
var dir

func init(dmg, spd):
	damage = dmg
	speed = spd
	return self

# Called when the node enters the scene tree for the first time.
func _ready():
	var currEnemy
	var dist = 99999
	var enemies = GameMaster.get_enemy_objects()
	if enemies.size() < 1: 
		dying = true
		queue_free()
	else:
		for enemy in enemies:
			var temp_dist = global_transform.origin.distance_to(enemy.global_transform.origin)
			if temp_dist < dist:
				dist = temp_dist
				currEnemy = enemy
		lockedOn = currEnemy.global_position
		dir = (lockedOn - global_position).normalized()
		global_rotation = dir.angle() + PI / 2.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !dying && lockedOn:
		translate(dir*speed*10*delta)
	else:
		queue_free()

func _on_Area2D_body_entered(body):
	if body.is_in_group("Enemies"):
		body.damage(damage)
		queue_free()

func _on_ttd_timeout():
	dying = true
