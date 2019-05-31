# #############################################################################
# #############################################################################
extends Panel
tool 
var ColorWheel = load('res://addons/PickerOfColors/color_wheel.gd')
var _color = Color(1,1,1)
export var size : int
export var width : int
var _color_wheel

signal value_changed(c)

func _ready():
	_color_wheel = ColorWheel.new(size, width)
	set_selected_color(Color(.5, .5, .5))

	_color_wheel.set_position(Vector2(rect_size.x,rect_size.y)*0.5 - Vector2(width*0.5,width*2 + 20))
	add_child(_color_wheel)
	_color_wheel.connect('selected', self, '_on_wheel_selected')
	_color_wheel.set_index(0)
	_color_wheel.set_value(1)
	update()

func _on_wheel_selected(color):
	set_selected_color(color)
	update()
	emit_signal("value_changed", color)

func set_selected_color(color):
	_color = color
	_color_wheel.set_color(color)
	update()

func get_selected_color():
	return _color

func _on_SelectButton_button_down():
	hide()
	pass # Replace with function body.

func _on_HSlider_value_changed(value):
	_color_wheel.set_value(value)
	pass # Replace with function body.
