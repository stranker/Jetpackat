extends KinematicBody2D

export var jump_speed : float = 700
export var horizontal_jump_speed : float = 300
export var slide_speed : float = 400
export var min_recover_height : int = 10
var velocity : Vector2
var jump_direction : int = 1
var GRAVITY = 1600
var activated : bool = false 
var size_sprite : Vector2
var invencible : bool = false
var can_receive_damage : bool = true
var dead : bool = false
var has_aegis : bool = false
var die_position : Vector2
var can_recover : bool = false
onready var initial_pos_x : float = position.x

signal start_playing
signal dead
signal current_height(value)
signal on_magnet(time)
signal on_recover
signal show_dead_ui

func _ready():
	initialize()
	pass

func _input(event):
	if event.is_action_pressed("ui_up") and !event.is_echo():
		recover()

func initialize():
	$Visible.scale.x = -jump_direction
	$Visible/Jetpack/Thruster.emitting = false
	size_sprite = $Visible/Skin.texture.get_size() * $Visible/Skin.scale / $Visible/Skin.hframes
	position = Vector2(get_viewport_rect().size.x, 0) * 0.5
	GameManager.player = self
	set_physics_process(activated)
	$Visible/Shield.hide()
	$GameCamera.initialize()
	pass

func _physics_process(delta):
	if activated:
		if !invencible:
			velocity.y += GRAVITY * delta
		if is_on_floor():
			velocity.x = 0
		move_and_slide(velocity,Vector2.UP)
	pass

func _process(delta):
	if activated:
		check_boundaries()
		process_animation()
		if !is_on_floor():
			var height = int(abs(position.y) * 0.01)
			emit_signal('current_height', height)
			if !can_recover:
				if height > min_recover_height:
					can_recover = true
		$Visible/Jetpack/Thruster.emitting = velocity.y < 0
	pass

func process_animation():
	if !is_on_floor():
		if velocity.y < 450:
			$Visible/Scarf/Anim.play('Flying')
		else:
			$Visible/Scarf/Anim.play('Falling')
	else:
		$Anim.play('Idle')
		$Visible/Scarf/Anim.play('Idle')
	pass

func check_boundaries():
	if position.x < size_sprite.x * 0.5:
		position.x = size_sprite.x * 0.5
	elif position.x > get_viewport_rect().size.x - size_sprite.x:
		position.x = get_viewport_rect().size.x - size_sprite.x
	pass

func check_is_active():
	if !activated:
		activated = !activated
		emit_signal('start_playing')
		set_physics_process(activated)
		$Visible/Scarf/Anim.play('Flying')
	pass

func take_damage():
	if invencible or has_aegis:
		Debug.debug("Invencible or aegis")
		return
	if !dead and can_receive_damage:
		on_dead()
	pass

func height_damage():
	if !dead:
		on_dead()
	pass

func on_dead():
	$Hit.play()
	dead = true
	check_die_direction()
	set_physics_process(false)
	$Visible/MagnetArea.deactivate()
	$Anim.stop()
	$Anim.play('Dead')
	$GameCamera.follow_player()
	$Visible/Arrow.hide()
	die_position = global_position
	can_receive_damage = false
	pass

func recover():
	dead = false
	global_position = Vector2(initial_pos_x, die_position.y)
	$Falling.volume_db = -80
	$Anim.play_backwards("Dead")
	can_recover = false
	pass

func check_die_direction():
	if global_position.x < get_viewport_rect().size.x * 0.5:
		$Visible.scale.x = 1
	else:
		$Visible.scale.x = -1
	pass

func _on_VisibilityNotifier2D_screen_exited():
	if !get_tree().paused:
		height_damage()
	pass

func _on_Area_gui_input(event):
	if !invencible:
		jump_control(event)
	else:
		slide_control(event)
	pass

func jump_control(event : InputEvent):
	if event is InputEventScreenTouch:
		if !event.is_echo() and event.pressed and !dead and !invencible:
			check_is_active()
			jump(jump_speed)
	pass

func slide_control(event : InputEvent):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			check_scale_direction(jump_direction)
			move_and_slide(Vector2.RIGHT * jump_direction * slide_speed, Vector2.UP)

func jump(jforce : int):
	check_scale_direction(jump_direction)
	velocity.y = -jforce
	$Sample.play()
	$Visible/Jetpack/Anim.play('Propulsion')
	pass

func check_scale_direction(dir):
	$Visible.scale.x = -dir
	velocity.x = dir * horizontal_jump_speed
	pass

func _on_Anim_animation_finished(anim_name):
	if anim_name == 'TimeOut':
		get_tree().root.get_node('GameScene').end_game()
	if anim_name == "Dead":
		if dead:
			emit_signal("show_dead_ui")
		if !dead:
			emit_signal("on_recover")
			$Falling.volume_db = -16
			yield(get_tree().create_timer(2.2),"timeout")
			can_receive_damage = true
			set_physics_process(true)
	pass # Replace with function body.

func impulse(force):
	velocity.y = -force
	pass

func on_aegis(value : bool):
	has_aegis = value
	if has_aegis:
		$Visible/AegisWings/Anim.play("Idle")
	else:
		$Visible/AegisWings/Anim.play("Used")
	pass

func on_fuel_master(time : int):
	invencible = true
	$Visible/Shield.visible = true
	$GameCamera.set_wind_effect(time)
	$Invencible.play()
	$Anim.play('Invencible')
	$Visible/Shield/Anim.play('ShieldOn')
	impulse(1500)
	pass

func hide_tutorial_arrow():
	$Visible/Arrow/Anim.play('Hide')
	pass

func _on_Invencible_toggled(button_pressed):
	can_receive_damage = !button_pressed
	pass # Replace with function body.

func disable_tutorial():
	$Visible/Arrow.hide()
	pass

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	_on_VisibilityNotifier2D_screen_exited()
	pass # Replace with function body.

func _on_Left_gui_input(event):
	jump_direction = -1
	check_movement_type(event)
	pass # Replace with function body.

func _on_Right_gui_input(event):
	jump_direction = 1
	check_movement_type(event)
	pass # Replace with function body.

func check_movement_type(event):
	if !invencible:
		jump_control(event)
	else:
		slide_control(event)

func _on_GameScene_on_fuel_completed(time):
	on_fuel_master(time)
	pass # Replace with function body.

func deactivate_magnet():
	$Visible/MagnetArea.deactivate()
	pass

func on_invencible_timeout():
	if invencible:
		invencible = false
		$Visible/Shield.visible = false
		$GameCamera.stop_wind()
		$Anim.play("Idle")
		$Visible/Shield/Anim.stop()
		Debug.debug_var("Invencible", invencible)
	if has_aegis:
		has_aegis = false
		$Visible/AegisWings/Anim.play("Used")
		Debug.debug_var("aegis", has_aegis)
	pass

func _on_GameScene_on_magnet(time):
	emit_signal('on_magnet', time)
	pass # Replace with function body.

func _on_GameScene_on_aegis(time):
	$Visible/AegisWings/Anim.play("Idle")
	has_aegis = true
	pass # Replace with function body.
