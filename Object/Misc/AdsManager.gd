extends Node

var admob : Admob = null
var interstitial_id = "ca-app-pub-5984635562124967/3443106433"
var rewarded_id = "ca-app-pub-5984635562124967/4062053536"

signal interstitial_closed
signal interstitial_loaded
signal interstitial_failed
signal reward_success
signal reward_failed
signal reward_closed

var showing_interstitial : bool = false

func _ready():
	ConnectionDetection.connect("connection_success", self, "on_connection_success")
	ConnectionDetection.connect("error_connection_failed", self, "on_connection_failed")
	ConnectionDetection.connect("error_ssl_handshake", self, "on_ssl_failed")
	create_admob()
	pass

func create_admob():
	if admob:
		return
	admob = Admob.new()
	get_tree().root.call_deferred("add_child",admob)
	admob.banner_on_top = false
	admob.interstitial_id = interstitial_id
	admob.rewarded_id = rewarded_id
	admob.is_real = false
	admob.connect("insterstitial_failed_to_load",self, "on_interstitial_failed")
	admob.connect("interstitial_closed",self, "on_interstitial_closed")
	admob.connect("interstitial_loaded",self, "on_interstitial_loaded")
	admob.connect("rewarded_video_failed_to_load", self, "on_reward_failed")
	admob.connect("rewarded", self, "on_reward_success")
	admob.connect("rewarded_video_closed", self, "on_reward_closed")
	load_interstitial()
	load_reward()
	pass

func on_reward_failed(error_code):
	Debug.debug("Failed Loading Reward:" + str(error_code))
	pass

func on_reward_success(currency, ammount):
	emit_signal("reward_success")
	pass

func on_reward_closed():
	emit_signal("reward_closed")
	pass

func on_interstitial_failed(code):
	Debug.debug("Failed Loading inter:" + str(code))
	emit_signal("interstitial_failed")
	pass

func on_interstitial_closed():
	Debug.debug("Closed Inter")
	emit_signal("interstitial_closed")
	pass

func on_interstitial_loaded():
	Debug.debug("Loaded inter")
	emit_signal("interstitial_loaded")
	pass

func load_interstitial():
	admob.load_interstitial()
	Debug.debug("Loading inter")
	pass

func load_reward():
	admob.load_rewarded_video()
	Debug.debug("Loading Reward")
	pass

func show_interstitial():
	showing_interstitial = true
	ConnectionDetection.start_check()
	pass

func show_reward():
	admob.show_rewarded_video()
	pass

func is_interstitial_loaded():
	return admob.is_interstitial_loaded()

func on_connection_success():
	if showing_interstitial and is_interstitial_loaded():
		admob.show_interstitial()
		showing_interstitial = false
	pass

func on_connection_failed(error, message):
	if showing_interstitial:
		emit_signal("interstitial_failed")
		showing_interstitial = false
	pass

func on_ssl_failed():
	if showing_interstitial:
		emit_signal("interstitial_failed")
		showing_interstitial = false
	pass
