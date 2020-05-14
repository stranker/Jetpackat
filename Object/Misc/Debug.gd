extends Node

var debug_control = preload("res://Object/Misc/Debug.tscn")

var debug_panel = null

func _ready():
	debug_panel = debug_control.instance()
	get_tree().root.call_deferred("add_child", debug_panel)
	pass # Replace with function body.


func debug(text):
	debug_panel.set_text(text)
	pass
