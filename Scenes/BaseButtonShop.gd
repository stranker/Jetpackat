extends TextureButton

var clicked = false
signal on_clicked(self_ref)
var ref_item = null
export (Texture) var button_texture

func _ready():
	if !button_texture:
		return
	set_textures(button_texture)
	$Shadow.texture = button_texture
	rect_pivot_offset = rect_size * 0.5
	pass

func set_textures(new_texture : Texture):
	texture_pressed = new_texture
	texture_disabled = new_texture
	texture_focused = new_texture
	texture_hover = new_texture
	texture_normal = new_texture
	pass

func unclick_button():
	$Anim.stop()
	$Anim.play('Idle')
	rect_scale = Vector2(1,1)
	clicked = false
	pass

func _on_ButtonShop_button_down():
	if !clicked:
		$Anim.play('Clicked')
		clicked = true
		emit_signal("on_clicked",self)
	pass # Replace with function body.

func set_item(item):
	ref_item = item
	pass

func upgrade_item():
	ref_item.upgrade_item()
	pass

func _on_ButtonShop_resized():
	rect_pivot_offset = rect_size * 0.5
	pass # Replace with function body.
