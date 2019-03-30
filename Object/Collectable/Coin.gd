extends Area2D

var taked : bool = false
export var value : int = 1

signal taken(val)

func _ready():
	connect('taken',get_tree().root.get_node('GameScene'),'add_coin')

func _on_Coin_body_entered(body):
	if body.is_in_group('Player') and !taked:
		taked = !taked
		emit_signal('taken',value)
		$Anim.play('Taken')
	pass # Replace with function body.
