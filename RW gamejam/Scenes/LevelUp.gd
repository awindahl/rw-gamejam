extends Control

var icon_folder = "res://Assets/"
onready var player = get_parent().get_parent()
onready var btn = $Button
onready var btn2 = $Button2
onready var btn3 = $Button3
onready var btn4 = $Button4
onready var buttons = [btn, btn2, btn3, btn4]
var pool = []

func _ready():
	pass

#func _process(delta):
#	pass

func level_up():
	pool = []
	var accepted_weapons = []
	var banned_weapons = []
	var random_weapons = []
	var equipped_weapons = player.get_player_weapons()
	for weapon in equipped_weapons:
		if weapon.level < DataMaster.weapons[weapon.id]["maxLevel"]:
			accepted_weapons.append(weapon.id)
		else:
			banned_weapons.append(weapon.id)
	for _i in 4:
		var temp_pool = []
		var random_roll = randi() % 101
		if (random_roll > DataMaster.rarity.epic):
			for obj in DataMaster.weapons:
				if DataMaster.weapons[obj]["rarity"] == "epic":
					temp_pool.append(obj)
			random_weapons.append(temp_pool[randi() % temp_pool.size()])
		elif (random_roll > DataMaster.rarity.rare):
			for obj in DataMaster.weapons:
				if DataMaster.weapons[obj]["rarity"] == "rare":
					temp_pool.append(obj)
			random_weapons.append(temp_pool[randi() % temp_pool.size()])
		else:
			for obj in DataMaster.weapons:
				if DataMaster.weapons[obj]["rarity"] == "common":
					temp_pool.append(obj)
			random_weapons.append(temp_pool[randi() % temp_pool.size()])
			
	for weapon_id in accepted_weapons:
		pool.append(weapon_id)
	var notMaxed = player.weapon_max_slots > equipped_weapons.size()
	if notMaxed:
		for weapon_id in random_weapons:
			if !pool.has(weapon_id) && !banned_weapons.has(weapon_id):
				pool.append(weapon_id)
	pool.shuffle()
	var counter = 0;
	for _i in pool.size():
		if counter < 4:
			_update_button(pool[_i])
			counter+=1
	if !btn.disabled:
		btn.grab_focus()

func _update_button(item_info):
	for _btn in buttons:
		if _btn.disabled:
			_btn.disabled = false
			_btn.visible = true
			_btn.text = DataMaster.weapons[item_info]["name"]
			_btn.icon = load(icon_folder + DataMaster.weapons[item_info]["icon"] + ".png")
			_btn.get_node("TextureRect").texture = load(icon_folder + DataMaster.weapons[item_info]["element"] + ".png")
			_btn.get_node("RichTextLabel").text = DataMaster.weapons[item_info]["levels"][str(player.get_weapon_level(item_info))]["desc"]
			break

func _on_Button_button_down():
	visible = false
	for _btn in buttons:
		_btn.disabled = true
		_btn.visible = false
	get_tree().paused = false
	player.give_weapon(pool[0])

func _on_Button2_button_down():
	visible = false
	for _btn in buttons:
		_btn.disabled = true
		_btn.visible = false
	get_tree().paused = false
	player.give_weapon(pool[1])

func _on_Button3_button_down():
	visible = false
	for _btn in buttons:
		_btn.disabled = true
		_btn.visible = false
	get_tree().paused = false
	player.give_weapon(pool[2])

func _on_Button4_button_down():
	visible = false
	for _btn in buttons:
		_btn.disabled = true
		_btn.visible = false
	get_tree().paused = false
	player.give_weapon(pool[3])


func _on_Skip_level_button_down():
	visible = false
	for _btn in buttons:
		_btn.disabled = true
		_btn.visible = false
	get_tree().paused = false
