extends Node

export (Array, PackedScene) var item_list
export(NodePath) var parent_node
export(NodePath) var spawn_points_node
export var activated : bool = true
export var min_height : float
export var max_height : float
onready var spawn_points = get_node(spawn_points_node).get_children()
var height_spawn : float
var pos_player_last_spawn : int

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.

func get_new_height():
	height_spawn = rand_range(min_height,max_height)
	pass

func check_can_spawn(): 
	return GameManager.player_height > height_spawn + pos_player_last_spawn

func spawn_item(item_scene : PackedScene):
	if !item_scene:
		return
	var item = item_scene.instance()
	var new_pos = Vector2()
	spawn_points.shuffle()
	get_node(parent_node).call_deferred('add_child',item)
	new_pos.x = spawn_points[0].position.x
	new_pos.y = GameManager.camera.global_position.y - get_viewport().get_viewport().size.y / 2 - 200
	item.global_position = new_pos
	pos_player_last_spawn = GameManager.player_height
	get_new_height()
	pass

func set_active(val):
	activated = val