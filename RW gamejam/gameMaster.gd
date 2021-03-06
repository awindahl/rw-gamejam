extends Node

onready var enemy = preload("res://Enemy.tscn")
onready var viewport_size = get_viewport().get_visible_rect().size
var level
var camera
export var levelScene = "TestBench"
var time = 0
var visible_enemies = []
var looping_edge_limit = 100

func _ready():
	randomize()
	level = load("res://"+ levelScene + ".tscn").instance()
	get_node("/root/GameScene").add_child(level)
	camera = level.get_node("YSort/Player")

func _process(delta):
	time+=delta
	if (time > 3):
		time = 0
		var coords = get_coordinates_on_viewport(viewport_size*1.2, randi() % 360)
		var childEnemy
		if (randi() % 10 > 4):
			childEnemy = enemy.instance().init("bat_sheet", "flying", 31, 75, 0, 1)
		else:
			childEnemy = enemy.instance().init("skele_sheet", "ground", 60, 20, 1, 2)
		childEnemy.position = Vector2(camera.position.x + coords.x, camera.position.y + coords.y)
		level.get_node("YSort/EnemyContainer").add_child(childEnemy)
	
	for enemy_obj in get_enemy_objects():
		if enemy_obj.position.x < camera.position.x-viewport_size.x/2-looping_edge_limit: enemy_obj.position.x = camera.position.x+viewport_size.x/2+looping_edge_limit
		if enemy_obj.position.x > camera.position.x+viewport_size.x/2+looping_edge_limit: enemy_obj.position.x = camera.position.x-viewport_size.x/2-looping_edge_limit
		if enemy_obj.position.y < camera.position.y-viewport_size.y/2-looping_edge_limit: enemy_obj.position.y = camera.position.y+viewport_size.y/2+looping_edge_limit
		if enemy_obj.position.y > camera.position.y+viewport_size.y/2+looping_edge_limit: enemy_obj.position.y = camera.position.y-viewport_size.y/2-looping_edge_limit

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

func get_enemies_inside_viewport():
	return visible_enemies

func add_visible_enemy(object):
	if !visible_enemies.has(object):
		visible_enemies.append(object)
	
func remove_visible_enemy(object):
	var id = visible_enemies.find(object)
	if id != -1:
		visible_enemies.remove(id)
	
func get_enemy_objects():
	return level.get_node("YSort/EnemyContainer").get_children()
	
func get_pickup_objects():
	return level.get_node("YSort/PickupContainer").get_children()
