extends "res://Object/Collectable/Collectable.gd"

func _ready():
	pass # Replace with function body.

func _process(delta):
	if GameManager.player.on_magnet and !taked:
		queue_free()

func _on_Magnet_body_entered(body):
	if body.is_in_group('Player') and !taked:
		taked = !taked
		$Anim.play('Taken')
		body.set_magnet(taked)
	pass # Replace with function body.


func _on_Magnet_area_entered(area):
	if area.name == 'MagnetArea' and !on_magnet_area:
		player_magnet = area
		on_magnet_area = !on_magnet_area
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	pass # Replace with function body.
