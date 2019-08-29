extends 'res://Object/Misc/Spawner.gd'

export (Array, String) var enemy_list
export (Array, int) var height_control_list
export var min_height_tutorial : int = 10
export (NodePath) var pool_manager
export (NodePath) var enemies_pos
enum SpawnType {COLLECTABLE, ENEMY}
export var spawn_type = SpawnType.COLLECTABLE

func _process(delta):
	if activated:
		if GameManager.player_height >= min_height_tutorial:
			if check_can_spawn():
				var item = get_new_item()
				spawn_item(item)
	pass

func get_new_item():
	var item = null
	var spawned : bool = false
	for i in range(height_control_list.size() - 1, -1 ,-1):
		if !spawned and GameManager.player_height > height_control_list[i]:
			item = get_node(pool_manager).get_object_by_name(enemy_list[i])
			spawned = true
	return item

func _on_Player_invencible(val):
	set_active(!val)
	pass # Replace with function body.
