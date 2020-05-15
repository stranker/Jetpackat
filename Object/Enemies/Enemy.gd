extends Node2D

signal active(val)
signal dispose(obj)

var activated : bool = false
var can_attack : bool = true

func _ready():
	randomize()

func _process(delta):
	if activated:
		if global_position.y > GameManager.player.global_position.y + get_viewport_rect().size.y:
			dispose_object()

func set_active(val):
	activated = val
	emit_signal('active',val)
	visible = val

func dispose_object():
	emit_signal('dispose',self)

func is_player(body):
	return body.is_in_group("Player")
