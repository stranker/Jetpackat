extends Area2D

var taked : bool = false
var player_magnet = null
export var value : int = 1
export var speed : int = 300

signal taken(val)

func _ready():
	randomize()
	connect('taken',get_tree().root.get_node('GameScene'),'add_coin')

func _process(delta):
	if player_magnet:
		var direction : Vector2 = (player_magnet.global_position - global_position).normalized()
		translate(direction*speed*delta)

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


func _on_Coin_area_entered(area):
	if area.name == 'MagnetArea':
		player_magnet = area
	pass # Replace with function body.
