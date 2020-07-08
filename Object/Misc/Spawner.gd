extends Node

export (Array, String) var item_list
export(NodePath) var spawn_points_node
export (NodePath) var pool_manager
export var activated : bool = true
export var min_height : float
export var max_height : float
onready var spawn_points : Array = get_node(spawn_points_node).get_children()
var height_spawn : float = 0
var pos_player_last_spawn : int = 0
enum SpawnType {COLLECTABLE, ENEMY, LAST}
export (SpawnType) var spawn_type = SpawnType.LAST

export var min_height_tutorial : int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.

func get_new_height():
	height_spawn = rand_range(min_height,max_height)
	pass

func check_can_spawn(): 
	return GameManager.player_height > min_height_tutorial and GameManager.player_height > height_spawn + pos_player_last_spawn and activated

func spawn_item(item_name):
	var item = get_node(pool_manager).get_object_by_name(item_name)
	if !item:
		return
	var item_pos : Vector2 = get_item_pos()
	item_pos.y = GameManager.camera.global_position.y - get_viewport().get_visible_rect().size.y * 0.6
	pos_player_last_spawn = GameManager.player_height
	item.call_deferred('set_global_position',item_pos)
	item.set_active(true)
	get_new_height()
	pass

func get_item_pos():
	return spawn_points[randi() % spawn_points.size()].global_position

func set_active(val):
	activated = val
