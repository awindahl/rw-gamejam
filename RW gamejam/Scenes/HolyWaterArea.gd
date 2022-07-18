extends Node2D

var damage = 0
var speed = 0
var duration = 0
var _area = 0
var enemies = []
var enemy_joined = []
var time = 0

func init(dmg, spd, drn, area):
	damage = dmg
	speed = spd
	_area = area
	duration = drn
	return self

func _ready():
	scale = Vector2(_area, _area)
	$duration.wait_time = duration
	$duration.start()

func _process(delta):
	for body in $Area2D.get_overlapping_bodies():
		if body.is_in_group("Enemies") && !enemies.has(body):
			enemies.append(body)
			enemy_joined.append(time)
	
	time += delta
	for i in enemy_joined.size():
		if enemy_joined[i]+speed < time && GameMaster.get_enemy_objects().has(enemies[i]):
			enemies[i].damage(damage)
			enemy_joined[i] = time

func _on_duration_timeout():
	queue_free()

func _on_Area2D_body_entered(body):
	if body.is_in_group("Enemies") && !enemies.has(body):
		enemies.append(body)
		enemy_joined.append(time)
