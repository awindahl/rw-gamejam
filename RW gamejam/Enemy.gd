extends KinematicBody2D

onready var animPlayer = $AnimationPlayer
onready var sprite = $Sprite

var _type = ""
var _speed = 0
var _health = 0
var _xp = 0

func init(spritesheet, type, health, speed, xp):
	_health = health
	_speed = speed
	_type = type
	_xp = xp
	var enemy_texture = load("res://images/" + spritesheet + ".png")
	sprite.texture = enemy_texture
	return self

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#func _process(delta):
#	follow player
# if health <= 0:
#	animPlayer.play("death")
