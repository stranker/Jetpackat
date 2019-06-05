extends Node

export (Array, PackedScene) var item_list
export(NodePath) var parent_node
export var activated : bool = true
export var min_height : float
export var max_height : float
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
	new_pos.x = rand_range(150,get_viewport().get_visible_rect().size.x - 150)
	new_pos.y = GameManager.camera.global_position.y - get_viewport().get_viewport().size.y / 2 - 200
	get_node(parent_node).add_child(item)
	item.position = new_pos
	pos_player_last_spawn = GameManager.player_height
	get_new_height()
	pass

func set_active(val):
	activated = val