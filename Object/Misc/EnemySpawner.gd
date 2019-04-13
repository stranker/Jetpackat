extends 'res://Object/Misc/Spawner.gd'

export (Array, int) var height_control_list

func _process(delta):
	if activated:
		if check_can_spawn():
			var item = get_new_item()
			spawn_item(item)
	pass

func get_new_item():
	var item = null
	var spawned : bool = false
	for i in range(height_control_list.size() - 1, -1 ,-1):
		if !spawned and GameManager.player_height > height_control_list[i]:
			item = item_list[i].instance()
			spawned = true
	return item