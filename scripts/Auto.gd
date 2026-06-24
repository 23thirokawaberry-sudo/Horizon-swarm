#Aim code#
extends Area2D

func get_player_damage():
	var player = get_parent()
	var player_damage = player.damage
	return player_damage

func _physics_process(delta):
	look_at(get_global_mouse_position())

func shoot_pistol():
	const BULLET = preload("res://scenes/Important/bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation
	%ShootingPoint.add_child(new_bullet)
	new_bullet.projectile_damage = get_player_damage()
	
func shoot_shotgun():
	const BULLET = preload("res://scenes/Important/bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation + randf_range(-0.3, 0.3)
	%ShootingPoint.add_child(new_bullet)
	new_bullet.projectile_damage = get_player_damage()

func _on_pistol_timeout():
	shoot_pistol()
func _on_shotgun_timeout():
	for i in range(6):
		shoot_shotgun()
