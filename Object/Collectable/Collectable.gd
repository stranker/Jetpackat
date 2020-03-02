extends Area2D

var activated : bool = false
var taked : bool = false
var player_magnet = null
export var value : int = 1
export var speed : int = 1000
var on_magnet_area : bool = false

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

func dispose_object():
	if activated:
		emit_signal('dispose',self)
	pass

func move_up():
	position += Vector2(0,-160)
	pass
