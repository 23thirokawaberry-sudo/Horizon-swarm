#Aim code#
extends Area2D

func get_player_damage():
	var player = get_parent()
	var attack_damage = player.damage
	return attack_damage

func _physics_process(delta):
	look_at(get_global_mouse_position())

func shoot():
	
	const BULLET = preload("res://scenes/Important/bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation
	%ShootingPoint.add_child(new_bullet)
	new_bullet.projectile_damage = get_player_damage()

func _on_timer_timeout():
	shoot()
