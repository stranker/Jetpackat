extends "res://Spawner.gd"

export (Array, int) var height_control_list

# Called when the node enters the scene tree for the first time.
func _ready():
	type = SPAWN_TYPE.ENEMY
	pass # Replace with function body.

func _process(delta):
	if activated:
		if check_can_spawn():
			var item = get_new_item()
			spawn_item(item,type)
	pass

func get_new_item():
	var item = null
	var spawned : bool = false
	for i in range(height_control_list.size() - 1, -1 ,-1):
		if !spawned and GameManager.player_height > height_control_list[i]:
			item = item_list[i].instance()
			spawned = true
	return item