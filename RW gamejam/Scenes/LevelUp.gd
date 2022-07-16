extends Control

onready var btn = $ColorRect/Button
onready var btn2 = $ColorRect/Button2
onready var btn3 = $ColorRect/Button3
onready var btn4 = $ColorRect/Button4

func _ready():
	# randomly get 4 items from pool
	# assign items to buttons
	pass

#func _process(delta):
#	pass

func _on_Button_button_down():
	visible = false
	get_tree().paused = false
	# give player item from button

func _on_Button2_button_down():
	visible = false
	get_tree().paused = false
	# give player item from button

func _on_Button3_button_down():
	visible = false
	get_tree().paused = false
	# give player item from button

func _on_Button4_button_down():
	visible = false
	get_tree().paused = false
	# give player item from button
