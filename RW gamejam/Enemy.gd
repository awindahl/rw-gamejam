extends KinematicBody2D

onready var animPlayer = $AnimationPlayer
onready var sprite = $Sprite
onready var player = $"/root/TestBench/Player"
onready var coll = $Area2D/CollisionShape2D
onready var pickup = preload("res://Scenes/Pickup.tscn");
var _type = ""
var _speed = 0
var _health = 0
var _xp = 0
var _spriteSheet = ""

func init(spritesheet, type, health, speed, xp):
	_health = health
	_speed = speed
	_type = type
	_xp = xp
	_spriteSheet = spritesheet
	return self

func _ready():
	var enemy_texture = load("res://images/" + _spriteSheet + ".png")
	sprite.texture = enemy_texture

func _process(delta):
	var position_difference = player.position - position
	if (position.x > player.position.x):
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	move_and_slide(position_difference.normalized() * _speed)

func damage(ammount):
	_health = _health-ammount
	print(ammount)
	if (_health <= 0):
		_health = 0
		die()

func die():
	coll.disabled = true
	animPlayer.play("death")
	var new_pickup = pickup.instance().init(_xp)
	new_pickup.position = position
	get_parent().add_child(new_pickup)
	
func _on_Area2D_body_entered(body):
	if body.is_in_group("Player") and _health > 0:
		if not body.is_invincible:
			#TODO proper damage numbers
			body.damage(10)
			body.is_hit = true
			body.hit_dir = body.position - position
