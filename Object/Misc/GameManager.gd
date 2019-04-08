extends Node

var coins : int = 9999
var fishes : int = 9999
var playing : bool = false
var player_height : int = 0
var camera : Camera2D = null
var player = null
var sound_volume : int = 5 
var music_volume : int = 5 
var item_data : Dictionary = {}
var items_equipped : Dictionary = {}

func _ready():
	load_item_data_file()
	load_equipped_items_file()
	pass

func load_item_data_file():
	item_data = get_json_file_data('Data/ItemShopData.txt')
	pass

func load_equipped_items_file():
	items_equipped = get_json_file_data('Data/EquippedItemsData.txt')
	pass

func get_json_file_data(file_path):
	var file = File.new()
	var processed_data : Dictionary = {}
	file.open(file_path,File.READ)
	if file.is_open():
		var line = file.get_line()
		var raw_data = ""
		while !file.eof_reached():
			if !str(line).begins_with('//'):
				raw_data += line
			line = file.get_line()
		if typeof(parse_json(raw_data)) == TYPE_DICTIONARY:
			processed_data = parse_json(raw_data)
		file.close()
	return processed_data

func save_item_data_file():
	var file = File.new()
	file.open('Data/ItemShopData.txt',File.WRITE)
	file.store_line("// ITEM SHOP DATA")
	file.store_line("// JETPACKAT by Daniel 'Stranker' Natarelli")
	file.store_line(to_json(item_data))
	file.store_line("")
	file.close()
	pass

func save_equipped_item_file():
	var file = File.new()
	file.open('Data/EquippedItemsData.txt',File.WRITE)
	file.store_line("// EQUIPPED ITEMS DATA")
	file.store_line("// JETPACKAT by Daniel 'Stranker' Natarelli")
	file.store_line(to_json(items_equipped))
	file.store_line("")
	file.close()
	pass


func buy_item(item_type,item_name):
	item_data[item_type][item_name]['buyed'] = true
	save_item_data_file()
	pass

func equip_item(item_type,item_name):
	items_equipped[item_type] = item_name
	save_equipped_item_file()
	pass