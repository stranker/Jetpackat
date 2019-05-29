extends 'res://Object/Misc/Spawner.gd'

export (Array, float) var probability
export var decrease_on_invencible : int = 5

func _process(delta):
	if activated:
		if check_can_spawn():
			var item = get_new_item()
			spawn_item(item)
	pass

func get_new_item():
	var item = null
	var item_pos = 0
	var prob = rand_range(0,1)
	var spawned = false
	for i in probability:
		if prob <= i and !spawned:
			item = item_list[item_pos].instance()
			spawned = !spawned
		else:
			item_pos += 1
	return item

func set_height_if_invencible(val):
	if val:
		min_height -= decrease_on_invencible
		max_height -= decrease_on_invencible
	else:
		max_height += decrease_on_invencible
		min_height += decrease_on_invencible