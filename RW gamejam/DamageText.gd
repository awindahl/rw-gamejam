extends Node2D

var counter = 0;

func init(count):
	counter = count
	return self

# Called when the node enters the scene tree for the first time.
func _ready():
	$Textbox.set_text(str(counter))
	$AnimationPlayer.play('showText')

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func remove():
	queue_free()
