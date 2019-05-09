extends Area2D

var taked : bool = false
var player_magnet = null
export var value : int = 1
export var speed : int = 1000
var on_magnet_area : bool = false

signal taken(val)

func _ready():
	randomize()
	connect('taken',get_tree().root.get_node('GameScene'),'add_coin')

func _process(delta):
	if player_magnet and !taked:
		speed += delta * 1000
		var direction : Vector2 = (player_magnet.global_position - global_position).normalized()
		translate(direction*speed*delta)

func _on_Coin_body_entered(body):
	if body.is_in_group('Player') and !taked:
		taked = !taked
		emit_signal('taken',value)
		$Anim.play('Taken')
		$Anim.seek(rand_range(0,1),true)
	pass # Replace with function body.

func _on_Coin_area_entered(area):
	if area.name == 'MagnetArea' and !on_magnet_area:
		player_magnet = area
		on_magnet_area = !on_magnet_area
	pass
