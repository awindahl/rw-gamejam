extends Node

onready var enemy = preload("res://Enemy.tscn")
onready var viewport_size = get_viewport().get_visible_rect().size
onready var camera = $"/root/TestBench/YSort/Player"
var time = 0

func _ready():
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time+=delta
	if (time > 3):
		time = 0
		var coords = get_coordinates_on_viewport(viewport_size*1.2, randi() % 360)
		var childEnemy
		if (randi() % 10 > 4):
			childEnemy = enemy.instance().init("bat_sheet", "flying", 31, 75, 10)
		else:
			childEnemy = enemy.instance().init("skele_sheet", "ground", 60, 20, 100)
		childEnemy.position = Vector2(camera.position.x + coords.x, camera.position.y + coords.y)
		add_child(childEnemy)

func get_coordinates_on_viewport(rect, deg):
	var twopi = PI*2;
	var theta = deg * PI / 180
	
	while(theta < -PI):
		theta += twopi
	while(theta > PI):
		theta -= twopi
	
	var rect_atan = atan2(rect.y, rect.x)
	var tan_theta = tan(theta)
	var region
	
	if ((theta > -rect_atan) && (theta <= rect_atan)):
		region = 1
	elif ((theta > rect_atan) && (theta <= (PI - rect_atan))):
		region = 2
	elif ((theta > (PI - rect_atan)) || (theta <= -(PI - rect_atan))):
		region = 3
	else:
		region = 4
	
	var edge_point = Vector2(rect.x/2, rect.y/2)
	var x_factor = 1
	var y_factor = 1
	
	match (region):
		1: y_factor = -1
		2: y_factor = -1
		3: x_factor = -1
		4: x_factor = -1
	
	if (region == 1 || region == 3):
		edge_point.x += x_factor * (rect.x/2)
		edge_point.y += y_factor * (rect.x/2) * tan_theta
	else:
		edge_point.x += x_factor * (rect.y/(2 * tan_theta))
		edge_point.y += y_factor * (rect.y/2)
	
	return Vector2(edge_point.x-rect.x/2, edge_point.y-rect.y/2)
