extends Control

var icon_folder = "res://Assets/"
onready var btn = $Button
onready var btn2 = $Button2
onready var btn3 = $Button3
onready var btn4 = $Button4
var pool = []

func _ready():
	pass

#func _process(delta):
#	pass

func level_up():
	pool = []
	#check player items
	for _i in 4:
		var temp_pool = []
		var random_roll = randi() % 101
		if (random_roll > DataMaster.rarity.epic):
			for obj in DataMaster.weapons:
				if DataMaster.weapons[obj]["rarity"] == "epic" && !pool.has(obj):
					temp_pool.append(obj)
			if temp_pool.size() > 0:
				pool.append(temp_pool[randi() % temp_pool.size()])
		elif (random_roll > DataMaster.rarity.rare):
			for obj in DataMaster.weapons:
				if DataMaster.weapons[obj]["rarity"] == "rare" && !pool.has(obj):
					temp_pool.append(obj)
			if temp_pool.size() > 0:
				pool.append(temp_pool[randi() % temp_pool.size()])
		else:
			for obj in DataMaster.weapons:
				if DataMaster.weapons[obj]["rarity"] == "common" && !pool.has(obj):
					temp_pool.append(obj)
			if temp_pool.size() > 0:
				pool.append(temp_pool[randi() % temp_pool.size()])
	btn.text = DataMaster.weapons[pool[0]]["name"]
	btn.icon = load(icon_folder + DataMaster.weapons[pool[0]]["icon"] + ".png")
	btn.get_node("TextureRect").texture = load(icon_folder + DataMaster.weapons[pool[0]]["element"] + ".png")
	btn.get_node("RichTextLabel").text = DataMaster.weapons[pool[0]]["levels"][str(get_parent().get_parent().get_weapon_level(pool[0]))]["desc"]
	
	btn2.text = DataMaster.weapons[pool[1]]["name"]
	btn2.icon = load(icon_folder + DataMaster.weapons[pool[1]]["icon"] + ".png")
	btn2.get_node("TextureRect").texture = load(icon_folder + DataMaster.weapons[pool[1]]["element"] + ".png")
	btn.get_node("RichTextLabel").text = DataMaster.weapons[pool[1]]["levels"][str(get_parent().get_parent().get_weapon_level(pool[1]))]["desc"]
	
	btn3.text = DataMaster.weapons[pool[2]]["name"]
	btn3.icon = load(icon_folder + DataMaster.weapons[pool[2]]["icon"] + ".png")
	btn3.get_node("TextureRect").texture = load(icon_folder + DataMaster.weapons[pool[2]]["element"] + ".png")
	btn.get_node("RichTextLabel").text = DataMaster.weapons[pool[2]]["levels"][str(get_parent().get_parent().get_weapon_level(pool[2]))]["desc"]
	
	btn4.text = DataMaster.weapons[pool[3]]["name"]
	btn4.icon = load(icon_folder + DataMaster.weapons[pool[3]]["icon"] + ".png")
	btn4.get_node("TextureRect").texture = load(icon_folder + DataMaster.weapons[pool[3]]["element"] + ".png")
	btn.get_node("RichTextLabel").text = DataMaster.weapons[pool[3]]["levels"][str(get_parent().get_parent().get_weapon_level(pool[3]))]["desc"]
	
	btn.grab_focus()

func _on_Button_button_down():
	visible = false
	get_tree().paused = false
	get_parent().get_parent().give_weapon(pool[0])

func _on_Button2_button_down():
	visible = false
	get_tree().paused = false
	get_parent().get_parent().give_weapon(pool[1])

func _on_Button3_button_down():
	visible = false
	get_tree().paused = false
	get_parent().get_parent().give_weapon(pool[2])

func _on_Button4_button_down():
	visible = false
	get_tree().paused = false
	get_parent().get_parent().give_weapon(pool[3])
