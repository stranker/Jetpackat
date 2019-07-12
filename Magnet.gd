extends "res://Object/Collectable/Collectable.gd"

func _ready():
	connect('taken',get_tree().root.get_node('GameScene/PowerUpSpawner'),'deactivate')
	pass # Replace with function body.

func _process(delta):
	if GameManager.player.on_magnet:
		queue_free()
	pass

func _on_Magnet_body_entered(body):
	if body.is_in_group('Player') and !taked:
		taked = !taked
		$Anim.play('Taken')
		body.set_magnet(taked)
		emit_signal('taken')
	pass # Replace with function body.


func _on_Magnet_area_entered(area):
	if area.name == 'MagnetArea' and !on_magnet_area:
		player_magnet = area
		on_magnet_area = !on_magnet_area
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	pass # Replace with function body.
