extends KinematicBody2D

onready var damageText
onready var animPlayer = $AnimationPlayer
onready var sprite = $Sprite

onready var player = get_parent().get_parent().get_node("Player")
onready var coll = $Area2D/CollisionShape2D
onready var pickup

var _type = ""
var _speed = 0
var _health = 0
var _xptype = 0
var _spriteSheet = ""
var _scale = 1
var _dead = false

func init(spritesheet, type, health, speed, xptype, scaled):
	_health = health
	_speed = speed
	_type = type
	_xptype = xptype
	_spriteSheet = spritesheet
	_scale = scaled
	return self

func _ready():
	damageText = DataMaster.get_scene("/DamageText")
	pickup = DataMaster.get_scene("/Pickup")
	var enemy_texture = load("res://images/" + _spriteSheet + ".png")
	sprite.texture = enemy_texture
	scale = Vector2(_scale, _scale)
	if _type == "flying":
		set_collision_layer_bit(0, false)

func _process(_delta):
	var position_difference = player.position - position
	if (position.x > player.position.x):
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	var _m = move_and_slide(position_difference.normalized() * _speed)

func damage(ammount):
	_health = _health-ammount
	if (!_dead):
		var newDamage = damageText.instance().init(ammount)
		add_child(newDamage)
	if (_health <= 0 && !_dead):
		_health = 0
		_dead = true
		die()

func die():
	GameMaster.remove_visible_enemy(self)
	call_deferred("die_deferred")
	animPlayer.play("death")

func die_deferred():
	coll.disabled = true
	var new_pickup = pickup.instance().init("xp", _xptype)
	new_pickup.position = position
	get_parent().get_parent().get_node("PickupContainer").add_child(new_pickup)

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player") and _health > 0:
		if not body.is_invincible:
			#TODO proper damage numbers
			body.damage(10)
			body.is_hit = true
			body.hit_dir = body.position - position

func _on_VisibilityNotifier2D_screen_entered():
	GameMaster.add_visible_enemy(self)

func _on_VisibilityNotifier2D_screen_exited():
	GameMaster.remove_visible_enemy(self)
