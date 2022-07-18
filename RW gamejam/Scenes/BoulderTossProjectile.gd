extends Node2D

var angle = rand_range(-180, 180)*PI*2;
var radius = 350
var point_0
var point_2
var point_1
var time = 0
var damage
var speed
var duration = 0
var _area = 0
var lockedOn
var area = preload("res://Scenes/HolyWaterArea.tscn")
var image1 = preload("res://Assets/rock1.png")
var image2 = preload("res://Assets/rock2.png") 
var images = [image1, image2]

func init(dmg, spd, drn, a):
	damage = dmg
	speed = spd
	_area = a
	duration = drn
	return self

func _ready():
	$Sprite.set_texture (images[randi() % images.size()])
	var enemies = GameMaster.get_enemy_objects()
	if enemies.size() < 1:
		queue_free()
	else:
		point_0 = position
		point_2 = enemies[randi() % enemies.size()].global_transform.origin
		point_1 = point_0 + (point_2 - point_0)/2 + Vector2.UP *500.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (time < 1.0):
		time += 1.0 * delta
		var m1 = lerp(point_0, point_1, time)
		var m2 = lerp(point_1, point_2, time)
		position = lerp(m1, m2, time)
	else:
		$AnimationPlayer.play("die")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "die":
		var area_instance = area.instance().init(damage, speed, duration, _area)
		area_instance.position = global_transform.origin
		GameMaster.level.add_child(area_instance)
		queue_free()
