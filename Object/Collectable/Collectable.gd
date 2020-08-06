extends Area2D

export var activated : bool = false
var taked : bool = false
var player_magnet = null
export var value : int = 1
export var speed : int = 1000
var on_magnet_area : bool = false
onready var game_scene = get_tree().root.get_node('GameScene')

signal taken(val)
signal active(val)
signal dispose(obj)

func _process(delta):
	if activated and player_magnet and !taked:
		speed += delta * speed
		var direction : Vector2 = (player_magnet.global_position - global_position).normalized()
		translate(direction*speed*delta)

func set_active(val):
	activated = val
	player_magnet = null
	on_magnet_area = false
	taked = false
	speed = 1000
	emit_signal('active',val)
	call_deferred('visible',val)
	pass

func is_currency(area):
	var name_area : String = area.name.to_lower()
	return name_area.find('coin') >= 0 or name_area.find('fish') >= 0 or name_area.find('yarnball') >= 0

func can_be_taked():
	return !taked and activated

func dispose_object():
	if activated:
		emit_signal('dispose',self)
	pass

func move_up():
	global_position += Vector2(0,400)
	pass

func check_magnet_area(area):
	if area.name == 'MagnetArea' and !on_magnet_area and activated:
		player_magnet = area
		on_magnet_area = !on_magnet_area
	pass

func on_take():
	pass
