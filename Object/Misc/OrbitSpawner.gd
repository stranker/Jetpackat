extends 'res://Object/Misc/Spawner.gd'

func _process(delta):
	if activated:
		if check_can_spawn():
			var item = get_new_item()
			spawn_item(item)
	pass

func get_new_item():
	return item_list[0].instance()