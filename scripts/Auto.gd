#Aim code#
extends Area2D

@onready var player = get_parent()
	
func get_player_damage():
	var player_damage = player.damage
	return player_damage

#if level is -1, then weapon is not yet unlocked.
var weapon_levels = [-1, 0, -1, -1]
#Shotgun, Pistol, Sword, beam

@warning_ignore("unused_parameter")
func _physics_process(delta):
	look_at(get_global_mouse_position())

#Weapon functions ==========================================================================
func shoot_pistol():
	if weapon_levels[1] != -1:
		var weapon_damage = get_player_damage()
		if weapon_levels[1] > 0:
			weapon_damage = weapon_damage * 1.33
		else:
			weapon_damage = weapon_damage
		const BULLET = preload("res://scenes/Attacks/pistol_bullet.tscn")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation
		%ShootingPoint.add_child(new_bullet)
		new_bullet.projectile_damage = weapon_damage
	
func shoot_shotgun():
	if weapon_levels[0] != -1:
		var weapon_damage = get_player_damage()
		if weapon_levels[0] > 0:
			weapon_damage = (weapon_damage * 0.8) * 1.33
		else:
			weapon_damage = (weapon_damage * 0.8)
		const BULLET = preload("res://scenes/Attacks/shotgun_bullet.tscn")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation + randf_range(-0.45, 0.45)
		%ShootingPoint.add_child(new_bullet)
		new_bullet.projectile_damage = weapon_damage
	
func swing_sword():
	if weapon_levels[2] != -1:
		var weapon_damage = get_player_damage()
		if weapon_levels[1] > 0:
			weapon_damage = (weapon_damage * 1.5) * 1.2
		else:
			weapon_damage = (weapon_damage * 1.5)
		const BULLET = preload("res://scenes/Attacks/sword_slash.tscn")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation
		%ShootingPoint.add_child(new_bullet)
		new_bullet.projectile_damage = weapon_damage

func fire_beam():
	if weapon_levels[3] != -1:
		var weapon_damage = get_player_damage()
		if weapon_levels[1] > 0:
			weapon_damage = (weapon_damage * 0.75) * 1.33
		else:
			weapon_damage = (weapon_damage * 0.75)
		const BULLET = preload("res://scenes/Attacks/beam.tscn")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation
		%ShootingPoint.add_child(new_bullet)
		new_bullet.projectile_damage = weapon_damage

#Weapon calling ============================================================================


func _on_pistol_timeout():
	shoot_pistol()
func _on_shotgun_timeout():
	for i in range(6):
		shoot_shotgun()
func _on_sword_timeout():
	swing_sword()
func _on_beam_timeout():
	fire_beam()
