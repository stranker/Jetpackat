extends Area2D

var taked : bool = false
var player_magnet = null
export var value : int = 1
export var speed : int = 1000
var on_magnet_area : bool = false

signal taken(val)

func _process(delta):
	if player_magnet and !taked:
		speed += delta * 1000
		var direction : Vector2 = (player_magnet.global_position - global_position).normalized()
		translate(direction*speed*delta)