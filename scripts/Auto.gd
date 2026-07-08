#Aim code#
extends Area2D

@onready var player = get_parent()

func get_player_damage():
	var player_damage = player.damage
	return player_damage

#if level is -1, then weapon is not yet unlocked.
var weapon_levels = DataTransfer.weapons.duplicate()
var lantern = -1 #required
@warning_ignore("unused_parameter")
func _physics_process(delta):
	look_at(get_global_mouse_position())
	if lantern != weapon_levels[6]:
		lantern = weapon_levels[6]
		if %lantern.get_child(0):
			%lantern.get_child(0).queue_free()
		lantern_spawn()

#Weapon functions ==========================================================================
func shoot_pistol():
	if weapon_levels[1] != -1:
		var weapon_damage = get_player_damage()
		if weapon_levels[1] == 0:
			weapon_damage = (weapon_damage * 1)
		elif weapon_levels[1] < 3:
			weapon_damage = (weapon_damage * 1) * 1.25
		elif weapon_levels[1] >= 3:
			weapon_damage = (weapon_damage * 1) * 1.5
		const BULLET = preload("res://scenes/Attacks/pistol_bullet.tscn")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation
		%ShootingPoint.add_child(new_bullet)
		new_bullet.projectile_damage = weapon_damage
		if weapon_levels[1] < 2:
			%pistol.wait_time = 0.5
		elif weapon_levels[1] >= 2:
			%pistol.wait_time = (0.5 * 0.8)
	
func shoot_shotgun():
	if weapon_levels[0] != -1:
		var weapon_damage = get_player_damage()
		if weapon_levels[0] == 0:
			weapon_damage = (weapon_damage * 0.6)
		elif weapon_levels[0] >= 1:
			weapon_damage = (weapon_damage * 0.6) * 1.25
		const BULLET = preload("res://scenes/Attacks/shotgun_bullet.tscn")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation + randf_range(-0.6, 0.6)
		%ShootingPoint.add_child(new_bullet)
		new_bullet.projectile_damage = weapon_damage
		if weapon_levels[0] < 2:
			%shotgun.wait_time = 1.5
		elif weapon_levels[0] >= 2:
			%shotgun.wait_time = (1.5 * 0.8)
	
func swing_sword():
	if weapon_levels[2] != -1:
		var weapon_damage = get_player_damage()
		if weapon_levels[2] == 0:
			weapon_damage = (weapon_damage * 1.2)
		elif weapon_levels[2] < 3:
			weapon_damage = (weapon_damage * 1.2) * 1.25
		elif weapon_levels[2] >= 3:
			weapon_damage = (weapon_damage * 1.2) * 1.5
		const BULLET = preload("res://scenes/Attacks/sword_slash.tscn")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation
		%ShootingPoint.add_child(new_bullet)
		new_bullet.projectile_damage = weapon_damage
		if weapon_levels[2] < 2:
			%sword.wait_time = 2.0
		elif weapon_levels[2] >= 2:
			%sword.wait_time = (2.0 * 0.75)

func fire_beam():
	if weapon_levels[3] != -1:
		var weapon_damage = get_player_damage()
		if weapon_levels[3] == 0:
			weapon_damage = (weapon_damage * 0.6)
		elif weapon_levels[3] >= 1:
			weapon_damage = (weapon_damage * 0.6) * 1.25
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
			%beam.wait_time = (3.0 * 0.8)

func shoot_sniper():
	if weapon_levels[4] != -1:
		var weapon_damage = get_player_damage()
		if weapon_levels[4] == 0:
			weapon_damage = (weapon_damage * 1.8)
		elif weapon_levels[4] >= 1:
			weapon_damage = (weapon_damage * 1.8) * 1.2
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
			%sniper.wait_time = 4
		elif weapon_levels[4] >= 2:
			%sniper.wait_time = (4 * 0.8)

func shoot_gatlng():
	if weapon_levels[5] != -1:
		var weapon_damage = get_player_damage()
		if weapon_levels[5] == 0:
			weapon_damage = (weapon_damage * 0.3)
		elif weapon_levels[5] < 3:
			weapon_damage = (weapon_damage * 0.3) * 1.25
		elif weapon_levels[5] >= 3:
			weapon_damage = (weapon_damage * 0.3) * 1.5
		const BULLET = preload("res://scenes/Attacks/gatling.tscn")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation + randf_range(-0.125, 0.125)
		%ShootingPoint.add_child(new_bullet)
		new_bullet.projectile_damage = weapon_damage
		if weapon_levels[5] < 2:
			%gatling.wait_time = 0.15
		elif weapon_levels[5] >= 2:
			%gatling.wait_time = (0.15 * 0.75)

func lantern_spawn():
	if weapon_levels[6] != -1:
		var weapon_damage = get_player_damage()
		if weapon_levels[6] == 0:
			weapon_damage = (weapon_damage * 0.75)
		elif weapon_levels[6] >= 1:
			weapon_damage = (weapon_damage * 0.75) * 1.25
		const BULLET = preload("res://lantern.tscn")
		var new_bullet = BULLET.instantiate()
		if weapon_levels[6] < 3:
			new_bullet.get_child(2).queue_free()
			new_bullet.get_child(3).queue_free()
			new_bullet.get_child(4).queue_free()
		elif weapon_levels[6] >= 3:
			new_bullet.get_child(0).queue_free()
			new_bullet.get_child(1).queue_free()
		new_bullet.global_position = %ShootingPoint.global_position
		%lantern.add_child(new_bullet)
		new_bullet.projectile_damage = weapon_damage
		if weapon_levels[6] < 2:
			new_bullet.spin = 1.5
		elif weapon_levels[6] >= 2:
			new_bullet.spin = (1.5 * 1.2)

func sapper_sap():
	if weapon_levels[7] != -1:
		var overlapping_nodes = get_overlapping_bodies()
		if overlapping_nodes.is_empty():
			return null
		var target = null
		var lowest_num = INF
		var weapon_damage = get_player_damage()
		if weapon_levels[7] == 0:
			weapon_damage = (weapon_damage * 0.1)
		elif weapon_levels[7] >= 1:
			weapon_damage = (weapon_damage * 0.1) * 1.25
		const BULLET = preload("res://scenes/Attacks/sapper.tscn")
		var new_bullet = BULLET.instantiate()
		for enemies in overlapping_nodes:
			if enemies.health < lowest_num:
				lowest_num = enemies.health
				target = enemies
		if target and get_parent():
			new_bullet.points = [Vector2(0, 0), get_parent().to_local(target.global_position)]
			print(new_bullet.points)
			print(target.global_position)
			print(to_local(target.global_position))
		get_parent().add_child(new_bullet)
		target.take_damage(weapon_damage)
		if weapon_levels[7] < 2:
			%gatling.wait_time = 0.1
			new_bullet.firerate = 0.1
		elif weapon_levels[7] >= 2:
			%gatling.wait_time = (0.1 * 0.8)
			new_bullet.firerate = (0.1 * 0.8)

#Weapon calling ============================================================================

func _on_pistol_timeout():
	shoot_pistol()
func _on_shotgun_timeout():
	if weapon_levels[0] < 3:
		for i in range(5):
			shoot_shotgun()
	elif weapon_levels[0] >= 3:
		for i in range(7):
			shoot_shotgun()
func _on_sword_timeout():
	swing_sword()
func _on_beam_timeout():
	fire_beam()
func _on_sniper_timeout():
	shoot_sniper()
func _on_gatling_timeout():
	shoot_gatlng()
func _on_sapper_timeout():
	sapper_sap()
