extends TextureButton

var clicked = false
signal on_clicked(self_ref)
var ref_item = null
export (Texture) var button_texture
export var can_rescale : bool = false

func _ready():
	if !button_texture:
		return
	set_textures(button_texture)
	rect_pivot_offset = rect_size * 0.5
	pass

func set_textures(new_texture : Texture):
	texture_pressed = new_texture
	texture_disabled = new_texture
	texture_focused = new_texture
	texture_hover = new_texture
	texture_normal = new_texture
	$Shadow.texture = new_texture
	pass

func unclick_button():
	$Anim.stop()
	$Anim.play('Idle')
	rect_scale = Vector2(1,1)
	clicked = false
	pass

func _on_ButtonShop_button_down():
	click_button()
	pass # Replace with function body.

func click_button():
	if !clicked:
		$Anim.play("OnClick")
		if can_rescale:
			$Anim.queue("Clicked")
		clicked = true
		emit_signal("on_clicked",self)
	pass

func change_to_buy_state():
	$Anim.play("Idle")
	pass

func set_item(item):
	ref_item = item
	pass

func upgrade_item():
	ref_item.upgrade_item()
	pass

func _on_ButtonShop_resized():
	rect_pivot_offset = rect_size * 0.5
	pass # Replace with function body.

func _on_Anim_animation_finished(anim_name):
	if anim_name == "OnClick":
		if clicked:
			clicked = false
	pass # Replace with function body.
