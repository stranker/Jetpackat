extends 'res://Object/Misc/Spawner.gd'

export var min_height_tutorial : int

func _process(delta):
	if activated:
		if check_can_spawn() and GameManager.player_height >= min_height_tutorial:
			var item = get_new_item()
			spawn_item(item)
	pass

func get_new_item():
	return item_list[0].instance()