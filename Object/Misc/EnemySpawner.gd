extends 'res://Object/Misc/Spawner.gd'

export (Array, int) var items_max_height
export var enemy_idx : int = 0

func _process(delta):
	if check_can_spawn():
		update_enemy_index()
		spawn_item(get_new_item())
	pass

func get_new_item():
	return item_list[enemy_idx]

func update_enemy_index():
	if enemy_idx < item_list.size():
		if GameManager.player_height > items_max_height[enemy_idx]:
			enemy_idx += 1
	pass
