extends Node

onready var items
onready var enemies
onready var levels
onready var weapons
onready var passives
onready var xp
onready var rarity = { "common" : 40, "rare" : 75, "epic" : 95 } 

func _ready():
	read_files()
	print("Loaded settings")
	#TODO : load player data

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func read_files():
	print("Reading data directory")
	var file_path = "res://JSON_files/"
	var dir = Directory.new()
	if dir.open(file_path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while (file_name != ""):
			if !dir.current_is_dir():
				print("Found datafile: " + file_name)
				var file = File.new()
				file.open(file_path+file_name, File.READ)
				var content_as_text = file.get_as_text()
				var content_as_dictionary = parse_json(content_as_text)
				match file_name.split(".")[0]:
					"items":
						items = content_as_dictionary
					"enemies":
						enemies = content_as_dictionary
					"levels":
						levels = content_as_dictionary
					"weapons":
						weapons = content_as_dictionary
					"passives":
						passives = content_as_dictionary
					"xp":
						xp = content_as_dictionary
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access datapath.")
