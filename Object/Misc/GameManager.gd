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
var game_info : Dictionary = {}
var timer : float = 0
var intro_watched : bool = false
var private_url = 'A_qF1JJVd0iy5GKQGTuHjAXVoYJ4ml3kq7N2E5W0B16g'
var left_mode : bool = false
var easter = false
var tutorial_done : bool = false
var language = ''
var has_internet_connection : bool = false
var runs_played : int = 0
export var min_ad_height : int = 100
export var min_recover_height : int = 500
var can_revive : bool = true
var invencible_timer : Timer
var player_aegis : bool = false

signal on_player_aegis(invencible)
signal on_invencible_time(time)

func add_currency():
	coins = 99999
	fishes = 99999
	pass

func reset_stats():
	player_height = 0
	can_revive = true
	pass

func set_aegis_time(time : float):
	player_aegis = true
	invencible_timer.wait_time = time
	invencible_timer.start()
	emit_signal("on_player_aegis", player_aegis)
	pass

func _ready():
	load_data()
	change_music_volume(game_info['MusicVolume'])
	change_sound_volume(game_info['SoundVolume'])
	change_language()
	create_invencible_timer()
	pass

func create_invencible_timer():
	invencible_timer = Timer.new()
	invencible_timer.one_shot = true
	invencible_timer.connect("timeout", self, "on_invencible_timeout")
	add_child(invencible_timer)
	pass

func on_invencible_timeout():
	player_aegis = false
	invencible_timer.stop()
	emit_signal("on_player_aegis", player_aegis)
	pass

func _process(delta):
	if get_tree().is_queued_for_deletion():
		save_game_data()
	if player_aegis:
		emit_signal("on_invencible_time", invencible_timer.time_left)
	pass

func try_load_file_data(res_path):
	var file = File.new()
	var output : Dictionary = {}
	if file.file_exists(res_path):
		file.open(res_path,File.READ)
		output = parse_json(file.get_as_text())
		file.close()
	return output

func load_data():
	var dir = Directory.new()
	# DIDN'T SAVE ANYTHING LATER
	if !dir.dir_exists('user://Saves'):
		dir.make_dir('user://Saves')
		load_data_from('res://Data/')
		ItemManager.load_data_from('res://Data/')
	else:
		load_data_from('user://Saves/')
		ItemManager.load_data_from('user://Saves/')
	pass

func load_data_from(dir : String):
	game_info = try_load_file_data(dir + 'GameInfo.dat')
	if !game_info.empty():
		nickname = game_info['Nickname']
		coins = game_info['Coins']
		fishes = game_info['Fishes']
		highscore = game_info['Highscore']
		fuel = game_info['Fuel']
		music_volume = game_info['MusicVolume']
		sound_volume = game_info['SoundVolume']
		left_mode = game_info['LeftMode']
		tutorial_done = game_info['Tutorial']
		language = game_info['Language']
	save_game_data()
	pass

func save_game_data():
	save_current_game_info()
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
	game_info['Language'] = language
	if !game_info.empty():
		file.store_line(to_json(game_info))
		file.store_line("")
	file.close()
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
	if !has_internet_connection:
		return
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
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index('UI'),-32 + 6.4 * value)
	AudioServer.set_bus_mute(AudioServer.get_bus_index('UI'),value == 0)
	pass

func change_language():
	TranslationServer.set_locale(language.to_lower())
	pass

func on_connection_success():
	has_internet_connection = true
	Debug.debug("Internet connection success")
	ConnectionDetection.stop_check()
	pass

func on_connection_error(error, message):
	has_internet_connection = false
	Debug.debug(message)
	ConnectionDetection.stop_check()
	pass

func on_error_ssl_handshake():
	has_internet_connection = false
	Debug.debug("SSL Handshake error")
	ConnectionDetection.stop_check()
	pass

func add_run():
	if player_height >= min_ad_height:
		runs_played += 1
	pass

func can_show_recover():
	return can_revive and player_height >= min_recover_height and AdsManager.is_reward_loaded()

func can_show_interstitial():
	return runs_played % 3 == 0 and runs_played != 0 and AdsManager.is_interstitial_loaded()

func on_player_recover():
	can_revive = false
	pass

func is_player_invencible():
	if !player:
		return false
	return player.invencible
