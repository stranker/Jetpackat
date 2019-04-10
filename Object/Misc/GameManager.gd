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
var currency : Dictionary = {}
var execution : String = ""
var timer : float = 0

func _ready():
	currency['Coins'] = coins
	currency['Fishes'] = fishes
	load_data()
	pass

func load_data():
	item_data = try_load_file_data('res://Data/ItemShopData.dat')
	items_equipped = try_load_file_data('res://Data/EquippedItemsData.dat')
	currency = try_load_file_data('res://Data/Currency.dat')
	coins = currency['Coins']
	fishes = currency['Fishes']
	pass

func try_load_file_data(res_path):
	var file = File.new()
	var output : Dictionary = {}
	if file.file_exists(res_path):
		file.open(res_path,File.READ)
		output = parse_json(file.get_as_text())
		file.close()
	else:
		execution += "FILE " + res_path + " DOESNT EXISTS --"
	return output

func save_game_data():
	save_current_currency()
	save_equipped_item_file()
	save_item_data_file()
	pass

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
	currency['Coins'] = coins
	currency['Fishes'] = fishes
	file.store_line(to_json(currency))
	file.close()
	pass

func buy_item(item_type,item_name):
	item_data[item_type][item_name]['buyed'] = true
	save_game_data()
	pass

func equip_item(item_type,item_name):
	items_equipped[item_type] = item_name
	save_game_data()
	pass