extends Node

var coins : int = 0
var fishes : int = 0
var playing : bool = false
var player_height : int = 0
var camera : Camera2D = null
var player = null
var sound_volume : int = 5 
var music_volume : int = 5 
var item_data : Dictionary = {}
var items_equipped : Dictionary = {}
var execution : String = ""
var timer : float = 0

func _ready():
	try_load_user_data()
	if item_data.keys().empty():
		load_item_data_file()
	if items_equipped.keys().empty():
		load_equipped_items_file()
	try_load_currency()
	pass

func _process(delta):
	save_info(delta)
	pass

func save_info(delta):
	timer += delta
	if timer > 2:
		save_current_currency()
		save_equipped_item_file()
		save_item_data_file()
		timer = 0
	pass

func try_load_currency():
	var data = get_json_file_data('user://Currency.dat')
	if data:
		coins = data['Coins']
		fishes = data['Fishes']
	else:
		save_current_currency()
	pass

func try_load_user_data():
	item_data = get_json_file_data('user://ItemShopData.dat')
	items_equipped = get_json_file_data('user://EquippedItemsData.dat')
	pass

func load_item_data_file():
	item_data = get_json_file_data('res://Data/ItemShopData.dat')
	pass

func load_equipped_items_file():
	items_equipped = get_json_file_data('res://Data/EquippedItemsData.dat')
	pass

func get_json_file_data(file_path):
	var file = File.new()
	var processed_data : Dictionary = {}
	file.open(file_path,File.READ)
	if file.is_open():
		var raw_data = file.get_as_text()
		if typeof(parse_json(raw_data)) == TYPE_DICTIONARY:
			processed_data = parse_json(raw_data)
		file.close()
	return processed_data

func save_item_data_file():
	var file = File.new()
	file.open('user://ItemShopData.dat',File.WRITE)
	file.store_line(to_json(item_data))
	file.store_line("")
	file.close()
	pass

func save_equipped_item_file():
	var file = File.new()
	file.open('user://EquippedItemsData.dat',File.WRITE)
	file.store_line(to_json(items_equipped))
	file.store_line("")
	file.close()
	pass

func save_current_currency():
	var file = File.new()
	file.open('user://Currency.dat',File.WRITE)
	if file.is_open():
		var data : Dictionary = {}
		data['Coins'] = coins
		data['Fishes'] = fishes
		file.store_line(to_json(data))
		file.close()
	pass

func buy_item(item_type,item_name):
	item_data[item_type][item_name]['buyed'] = true
	save_item_data_file()
	save_current_currency()
	pass

func equip_item(item_type,item_name):
	items_equipped[item_type] = item_name
	save_equipped_item_file()
	save_current_currency()
	pass