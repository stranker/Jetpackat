extends Node

var nickname : String = ''
var coins : int = 0
var fishes : int = 0
var playing : bool = false
var player_height : int = 0
var fuel : int = 0
var camera : Camera2D = null
var highscore : int = 0
var player = null
var sound_volume : int = 0 
var music_volume : int = 0 
var item_data : Dictionary = {}
var items_equipped : Dictionary = {}
var game_info : Dictionary = {}
var timer : float = 0
var intro_watched : bool = false
var private_url = 'A_qF1JJVd0iy5GKQGTuHjAXVoYJ4ml3kq7N2E5W0B16g'
var left_mode : bool = false
var easter = false
var tutorial_done : bool = false

func reset_stats():
	player_height = 0
	pass

func _ready():
	load_data()
	change_music_volume(game_info['MusicVolume'])
	change_sound_volume(game_info['SoundVolume'])
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
		fuel = game_info['Fuel']
		music_volume = game_info['MusicVolume']
		sound_volume = game_info['SoundVolume']
		left_mode = game_info['LeftMode']
		tutorial_done = game_info['Tutorial']
	save_game_data()
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
		fuel = game_info['Fuel']
		intro_watched = game_info['IntroWatched']
		music_volume = game_info['MusicVolume']
		sound_volume = game_info['SoundVolume']
		left_mode = game_info['LeftMode']
		tutorial_done = game_info['Tutorial']
	save_game_data()
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

func save_item_data_res():
	var file = File.new()
	file.open('res://Data/ItemShopData.dat',File.WRITE)
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
	game_info['Fuel'] = fuel
	game_info['IntroWatched'] = intro_watched
	game_info['MusicVolume'] = music_volume
	game_info['SoundVolume'] = sound_volume
	game_info['LeftMode'] = left_mode
	game_info['Tutorial'] = tutorial_done
	if !game_info.empty():
		file.store_line(to_json(game_info))
		file.store_line("")
	file.close()
	pass

func buy_item(item_type,item_name):
	item_data[item_type][item_name]['buyed'] = true
	save_game_data()
	pass

func equip_item(item_type,item_name,color):
	items_equipped[item_type] = item_name
	if color:
		items_equipped[item_type] = [item_name,color]
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
	var count = 0
	while http_client.get_status() == HTTPClient.STATUS_CONNECTING or http_client.get_status() == HTTPClient.STATUS_RESOLVING:
		http_client.poll()
		OS.delay_msec(500)
		count += 1
		if count >= 4:
			return
	var err = http_client.request(HTTPClient.METHOD_GET,'/lb/'+private_url+'/add-pipe/'+nickname+'/'+str(highscore),[])
	return err

func int_to_time(number):
	var time_number : String = ''
	var second_to_minutes = number / 60.0
	var minute = floor(second_to_minutes)
	var seconds = floor((second_to_minutes - minute) * 60.0)
	if seconds <= 0.01:
		seconds = 0
	if minute > 0:
		time_number = str(minute) + ':' + str(seconds).pad_zeros(2)
	else:
		time_number = str(seconds)
	return time_number

func change_music_volume(value):
	music_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index('Music'),-32 + 6.4 * value)
	AudioServer.set_bus_mute(AudioServer.get_bus_index('Music'),value == 0)
	pass

func change_sound_volume(value):
	sound_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index('Sounds'),-32 + 6.4 * value)
	AudioServer.set_bus_mute(AudioServer.get_bus_index('Sounds'),value == 0)
	pass