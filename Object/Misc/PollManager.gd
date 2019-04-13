extends Node

export (Array,PackedScene) var enemies
export (Array,PackedScene) var collectables
export (Array,PackedScene) var ribbons
export (int) var game_items_amount = 0

var enemies_list = []
var collectables_list = []
var ribbons_list = []

# Called when the node enters the scene tree for the first time.
func _ready():
	enemies_list = create_objects(enemies)
	collectables_list = create_objects(collectables)
	ribbons_list = create_objects(ribbons)
	pass # Replace with function body.

func create_objects(list : Array):
	var output : Array = []
	for i in list.size():
		for j in range(game_items_amount):
			var item = list[i].instance()
			output.append(item)
	return output

func get_object(id,list):
	var obj = null
	for i in list:
		if i.get_id() == id and !i.is_on_screen():
			obj = i
	return obj