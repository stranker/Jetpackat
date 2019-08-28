extends Area2D

signal active(val)

var activated : bool = false

func set_active(val):
	activated = val
	emit_signal('active',val)