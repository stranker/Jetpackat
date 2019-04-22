extends Node

var nickname : String = ''
var coins : int = 0
var fishes : int = 0
var playing : bool = false
var player_height : int = 0
var camera : Camera2D = null
var highscore : int = 0
var player = null
var sound_volume : int = 5 
var music_volume : int = 5 
var item_data : Dictionary = {}
var items_equipped : Dictionary = {}
var game_info : Dictionary = {}
var timer : float = 0
var intro_watched : bool = false
var private_url = 'A_qF1JJVd0iy5GKQGTuHjAXVoYJ4ml3kq7N2E5W0B16g'

func _ready():
	load_data()
	pass

func load_data():
	try_create_directory()
	pass

func _process(delta):
	if get_tree().is_queued_for_deletion():
		save_game_data()

func load_data_from_res():
	item_data = try_load_file_data('res://Data/ItemShopData.dat')
	items_equipped = try_load_file_data('res://Data/EquippedItemsData.dat')
	game_info = try_load_file_data('res://Data/GameInfo.dat')
	if !game_info.empty():
		coins = game_info['Coins']
		fishes = game_info['Fishes']
		highscore = game_info['Highscore']
	pass

func load_data_from_user():
	item_data = try_load_file_data('user://Saves/ItemShopData.dat')
	items_equipped = try_load_file_data('user://Saves/EquippedItemsData.dat')
	game_info = try_load_file_data('user://Saves/GameInfo.dat')
	if !game_info.empty():
		nickname = game_info['Nickname']
		coins = game_info['Coins']
		fishes = game_info['Fishes']
		highscore = game_info['Highscore']
		game_info['IntroWatched'] = intro_watched
	pass

func try_create_directory():
	var dir = Directory.new()
	# DIDN'T SAVE ANYTHING LATER
	if !dir.dir_exists('user://Saves'):
		dir.make_dir('user://Saves')
		load_data_from_res()
	else:
		load_data_from_user()
	pass

func try_load_file_data(res_path):
	var file = File.new()
	var output : Dictionary = {}
	if file.file_exists(res_path):
		file.open(res_path,File.READ)
		output = parse_json(file.get_as_text())
		file.close()
	return output

func save_game_data():
	save_current_game_info()
	save_equipped_item_file()
	save_item_data_file()
	pass

func save_item_data_file():
	var file = File.new()
	file.open('user://Saves/ItemShopData.dat',File.WRITE)
	if !item_data.empty():
		file.store_line(to_json(item_data))
		file.store_line("")
	file.close()
	pass

func save_equipped_item_file():
	var file = File.new()
	file.open('user://Saves/EquippedItemsData.dat',File.WRITE)
	if !items_equipped.empty():
		file.store_line(to_json(items_equipped))
		file.store_line("")
	file.close()
	pass

func save_current_game_info():
	var file = File.new()
	file.open('user://Saves/GameInfo.dat',File.WRITE)
	game_info['Nickname'] = nickname
	game_info['Coins'] = coins
	game_info['Fishes'] = fishes
	game_info['Highscore'] = highscore
	game_info['IntroWatched'] = intro_watched
	if !game_info.empty():
		file.store_line(to_json(game_info))
		file.store_line("")
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

func reset_game_state():
	var dir = Directory.new()
	set_process(false)
	dir.remove('user://Saves/ItemShopData.dat')
	dir.remove('user://Saves/EquippedItemsData.dat')
	dir.remove('user://Saves/GameInfo.dat')
	dir.remove('user://Saves')
	get_tree().quit()
	pass

func upload_highscore():
	var http_client = HTTPClient.new()
	http_client.connect_to_host('http://dreamlo.com',80)
	while http_client.get_status() == HTTPClient.STATUS_CONNECTING or http_client.get_status() == HTTPClient.STATUS_RESOLVING:
		http_client.poll()
	var err = http_client.request(HTTPClient.METHOD_GET,'/lb/'+private_url+'/add/'+nickname+'/'+str(highscore),[])
	return err