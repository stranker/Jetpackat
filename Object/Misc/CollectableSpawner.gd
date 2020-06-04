extends 'res://Object/Misc/Spawner.gd'

export (Array, float) var item_probability

export var decrease_on_invencible : int = 5

func _process(delta):
	if check_can_spawn():
		spawn_item(get_new_item())
	pass

func get_new_item():
	var item_name : String = ''
	var item_prob = rand_range(0,1)
	for i in range(item_list.size()):
		if item_prob < item_probability[i]:
			item_name = item_list[i]
			break
	if item_name.empty():
		item_name = item_list[item_list.size()-1]
	return item_name

func set_height_if_invencible(val):
	if val:
		min_height -= decrease_on_invencible
		max_height -= decrease_on_invencible
	else:
		max_height += decrease_on_invencible
		min_height += decrease_on_invencible
