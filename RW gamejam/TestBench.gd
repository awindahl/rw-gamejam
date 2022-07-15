extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var enemy = load("res://Enemy.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#test-spawn specific enemy
	var childEnemy = enemy.instance().init("bat_sheet", "flying", 31, 25, 10)
	childEnemy.set_position(Vector2(150,150))
	#instance specific enemy
	add_child(childEnemy)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
