extends Node

var music_theme_path = 'res://Sounds/Music/Cats Can Fly Theme final.ogg'
var music_theme : AudioStreamOGGVorbis = null
var audio_player : AudioStreamPlayer = null 
var music_activated : bool = false


func create_soundtrack():
	if !music_activated:
		music_activated = true
		audio_player = AudioStreamPlayer.new()
		audio_player.pause_mode = Node.PAUSE_MODE_PROCESS
		get_tree().root.call_deferred('add_child',audio_player)
		audio_player.bus = "Music"
		music_theme = load(music_theme_path)
		audio_player.stream = music_theme
		audio_player.play()
	pass