extends TextureButton

func unclick_button():
	$Anim.play('Idle')
	pass

func _on_ButtonShop_button_down():
	$Anim.play('Clicked')
	pass # Replace with function body.
