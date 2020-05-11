extends TextureButton

var clicked = false
signal on_clicked(self_ref)
var ref_item = null

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


func _on_ButtonShop_mouse_entered():
	rect_scale = Vector2(1.2,1.2)
	pass # Replace with function body.


func _on_ButtonShop_mouse_exited():
	rect_scale = Vector2(1,1)
	pass # Replace with function body.

func set_item(item):
	ref_item = item
	pass

func upgrade_item():
	ref_item.upgrade_item()
	pass
