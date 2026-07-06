#Aim code#
extends Area2D

@onready var player = get_parent()
	
func get_player_damage():
	var player_damage = player.damage
	return player_damage

#if level is -1, then weapon is not yet unlocked.
var weapon_levels = DataTransfer.weapons

@warning_ignore("unused_parameter")
func _physics_process(delta):
	look_at(get_global_mouse_position())

#Weapon functions ==========================================================================
func shoot_pistol():
	if weapon_levels[1] != -1:
		var weapon_damage = get_player_damage()
		if weapon_levels[1] == 0:
			weapon_damage = (weapon_damage * 1.5)
		elif weapon_levels[1] < 3:
			weapon_damage = (weapon_damage * 1.5) * 1.33
		elif weapon_levels[1] >= 3:
			weapon_damage = (weapon_damage * 1.5) * 1.67
		const BULLET = preload("res://scenes/Attacks/pistol_bullet.tscn")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation
		%ShootingPoint.add_child(new_bullet)
		new_bullet.projectile_damage = weapon_damage
		if weapon_levels[1] < 2:
			%pistol.wait_time = 0.5
		elif weapon_levels[1] >= 2:
			%pistol.wait_time = (0.5 * 0.9)
	
func shoot_shotgun():
	if weapon_levels[0] != -1:
		var weapon_damage = get_player_damage()
		if weapon_levels[0] == 0:
			weapon_damage = (weapon_damage * 0.75)
		elif weapon_levels[0] >= 1:
			weapon_damage = (weapon_damage * 0.75) * 1.33
		const BULLET = preload("res://scenes/Attacks/shotgun_bullet.tscn")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation + randf_range(-0.45, 0.45)
		%ShootingPoint.add_child(new_bullet)
		new_bullet.projectile_damage = weapon_damage
		if weapon_levels[0] < 2:
			%shotgun.wait_time = 1.5
		elif weapon_levels[0] >= 2:
			%shotgun.wait_time = (1.5 * 0.9)
	
func swing_sword():
	if weapon_levels[2] != -1:
		var weapon_damage = get_player_damage()
		if weapon_levels[2] == 0:
			weapon_damage = (weapon_damage * 1.25)
		elif weapon_levels[2] < 3:
			weapon_damage = (weapon_damage * 1.25) * 1.25
		elif weapon_levels[2] >= 3:
			weapon_damage = (weapon_damage * 1.25) * 1.5
		const BULLET = preload("res://scenes/Attacks/sword_slash.tscn")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation
		%ShootingPoint.add_child(new_bullet)
		new_bullet.projectile_damage = weapon_damage
		if weapon_levels[2] < 2:
			%sword.wait_time = 2.0
		elif weapon_levels[2] >= 2:
			%sword.wait_time = (2.0 * 0.85)

func fire_beam():
	if weapon_levels[3] != -1:
		var weapon_damage = get_player_damage()
		if weapon_levels[3] == 0:
			weapon_damage = (weapon_damage * 0.625)
		elif weapon_levels[3] >= 1:
			weapon_damage = (weapon_damage * 0.625) * 1.33
		var weapon_size = 1.0
		if weapon_levels[3] >= 3:
			weapon_size = 2.0
		const BULLET = preload("res://scenes/Attacks/beam.tscn")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation
		new_bullet.scale = Vector2(1.0, weapon_size)
		%ShootingPoint.add_child(new_bullet)
		new_bullet.projectile_damage = weapon_damage
		if weapon_levels[3] < 2:
			%beam.wait_time = 3.0
		elif weapon_levels[3] >= 2:
			%beam.wait_time = (3.0 * 0.9)

func shoot_sniper():
	if weapon_levels[4] != -1:
		var weapon_damage = get_player_damage()
		if weapon_levels[4] == 0:
			weapon_damage = (weapon_damage * 2.5)
		elif weapon_levels[4] >= 1:
			weapon_damage = (weapon_damage * 2.5) * 1.2
		var weapon_pierce = 5.0
		if weapon_levels[4] <= 2:
			weapon_pierce = 5.0
		elif weapon_levels[4] >= 3:
			weapon_pierce = 8.0
		const BULLET = preload("res://scenes/Attacks/sniper.tscn")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation
		%ShootingPoint.add_child(new_bullet)
		new_bullet.projectile_damage = weapon_damage
		new_bullet.pierce = weapon_pierce
		if weapon_levels[4] < 2:
			%sniper.wait_time = 5
		elif weapon_levels[4] >= 2:
			%sniper.wait_time = (5 * 0.9)

func shoot_gatlng():
	if weapon_levels[5] != -1:
		var weapon_damage = get_player_damage()
		if weapon_levels[5] == 0:
			weapon_damage = (weapon_damage * 0.75)
		elif weapon_levels[5] >= 1:
			weapon_damage = (weapon_damage * 0.75) * 1.33
		const BULLET = preload("res://scenes/Attacks/shotgun_bullet.tscn")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation + randf_range(-0.05, 0.05)
		%ShootingPoint.add_child(new_bullet)
		new_bullet.projectile_damage = weapon_damage
		if weapon_levels[5] < 2:
			%gatling.wait_time = 0.1
		elif weapon_levels[5] >= 2:
			%gatling.wait_time = (0.1 * 0.8)

#Weapon calling ============================================================================


func _on_pistol_timeout():
	shoot_pistol()
func _on_shotgun_timeout():
	if weapon_levels[0] < 3:
		for i in range(6):
			shoot_shotgun()
	elif weapon_levels[0] >= 3:
		for i in range(8):
			shoot_shotgun()
func _on_sword_timeout():
	swing_sword()
func _on_beam_timeout():
	fire_beam()
func _on_sniper_timeout():
	shoot_sniper()
func _on_gatling_timeout():
	shoot_gatlng()
