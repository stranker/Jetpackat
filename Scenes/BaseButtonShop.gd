extends TextureButton

var clicked = false
signal on_clicked

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
		emit_signal("on_clicked")
	pass # Replace with function body.


func _on_ButtonShop_mouse_entered():
	rect_scale = Vector2(1.2,1.2)
	pass # Replace with function body.


func _on_ButtonShop_mouse_exited():
	rect_scale = Vector2(1,1)
	pass # Replace with function body.
