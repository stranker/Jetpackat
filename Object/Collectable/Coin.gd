extends Area2D

var taked : bool = false
export var value : int = 1

signal taken(val)

func _ready():
	randomize()
	connect('taken',get_tree().root.get_node('GameScene'),'add_coin')

func _on_Coin_body_entered(body):
	if body.is_in_group('Player') and !taked:
		taked = !taked
		emit_signal('taken',value)
		$Anim.play('Taken')
		$Anim.seek(rand_range(0,1),true)
	pass # Replace with function body.


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	pass # Replace with function body.
