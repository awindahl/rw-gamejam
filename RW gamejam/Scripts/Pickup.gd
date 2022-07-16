extends Area2D

var icon_folder = "res://Assets/"
var has_player = false
var Player = null
var speed = 5
export var _value = 0
export var _type = ""

func init(type, value):
	_type = type
	_value = value
	return self

func _ready():
	var pickup_image
	match _type:
		"xp":
			pickup_image = load(icon_folder + DataMaster.xp[str(_value)]["icon"] + ".png")
		"weapon":
			pickup_image = load(icon_folder + DataMaster.weapons[str(_value)]["icon"] + ".png")
		"passive":
			pass
		"consumable":
			pass
		"misc":
			pickup_image = load(icon_folder + "red_hat_icon.png")
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
			"xp":
				body.xp += DataMaster.xp[str(_value)]["value"]
				body.UI_update()
			"weapon":
				body.give_weapon(_value)
				body.weapon_update()
			"passive":
				pass
			"consumable":
				pass
			"misc":
				body.change_clothes("wizard_red")
		queue_free()
