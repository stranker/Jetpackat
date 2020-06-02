extends Control

var font = load("res://Fonts/test_font.tres")

func _process(delta):
	update()

func _draw():
	draw_string(font,Vector2.ONE * 20,"Zarlanga",Color.red,-1)
	pass
