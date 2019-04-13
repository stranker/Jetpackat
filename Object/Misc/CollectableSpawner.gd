extends 'res://Object/Misc/Spawner.gd'

export (Array, float) var probability

func _ready():
	type = SPAWN_TYPE.COLLECTABLE

func _process(delta):
	if activated:
		if check_can_spawn():
			var item = get_new_item()
			spawn_item(item,type)
	pass

func get_new_item():
	var item = null
	var item_pos = 0
	var prob = rand_range(0,1)
	var spawned = false
	for i in probability:
		if prob <= i and !spawned:
			item = PollManager.get_object(item_pos,PollManager.collectables_list)
			spawned = !spawned
		else:
			item_pos += 1
	return item