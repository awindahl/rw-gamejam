extends Area2D

enum itemTypes {XP, WEAPON, SECONDARY, HEALTH, GOLD, FREEZE, MISC}
enum weaponValue {WHIP, AXE, SPELL, SPELL2, SPELL3, SPELL4}
enum secondaryValue {ATTACKSPD, AREA, SIZE, XPGAIN, HP, HPREGEN}
enum goldValue {SMALL, MEDIUM, BIG, REALLYBIG}

var has_player = false
var Player = null
var speed = 5
export var _value = 0
export var _type = 0

func init(type, value):
	_type = type
	_value = value
	return self

func _ready():
	var pickup_image
	match _type:
		itemTypes.XP:
			pickup_image = load("res://Assets/placeholder_pickup.png")
		itemTypes.WEAPON:
			match _value:
				weaponValue.WHIP:
					pickup_image = load("res://Assets/whip_icon.png")
		itemTypes.MISC:
			pickup_image = load("res://Assets/red_hat_icon.png")
	$Sprite.texture = pickup_image

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if has_player:
		position.x = lerp(position.x, Player.position.x, delta*speed)
		position.y = lerp(position.y, Player.position.y, delta*speed)
	else:
		pass

func _on_Pickup_body_entered(body):
	if body.is_in_group("Player") && !has_player || body.is_in_group("Player") && Player == body:
		match _type:
			itemTypes.XP:
				body.xp += _value
				body.UI_update()
			itemTypes.WEAPON:
				call_deferred("_add_weapon_deferred", body, "WhipAttack")
			itemTypes.SECONDARY:
				pass
			itemTypes.HEALTH:
				pass
			itemTypes.GOLD:
				pass
			itemTypes.FREEZE:
				pass
			itemTypes.MISC:
				body.change_clothes("wizard_red")
		queue_free()

func _add_weapon_deferred(body, weapon):
	body.get_node("Weapons").add_child(load("res://Scenes/"+weapon+".tscn").instance())
	body.weapon_update()
