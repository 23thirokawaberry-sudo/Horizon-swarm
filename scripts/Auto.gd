#Aim code#
extends Area2D

@onready var player = get_parent()
func _ready():
	print(player)
	
func get_player_damage():
	var player_damage = player.damage
	return player_damage

#if level is -1, then weapon is not yet unlocked.
var weapon_levels = [0, -1]

func _physics_process(delta):
	look_at(get_global_mouse_position())

#Weapon functions ==========================================================================
func shoot_pistol():
	if weapon_levels[1] != -1:
		var weapon_damage = get_player_damage()
		print(weapon_damage)
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
			var damage = (weapon_damage * 0.75) * 1.33
			print("hi", damage)
		else:
			var damage = (weapon_damage * 0.75)
			print(damage)
		const BULLET = preload("res://scenes/Attacks/shotgun_bullet.tscn")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation + randf_range(-0.3, 0.3)
		%ShootingPoint.add_child(new_bullet)
		new_bullet.projectile_damage = weapon_damage

#Weapon calling ============================================================================


func _on_pistol_timeout():
	shoot_pistol()
func _on_shotgun_timeout():
	for i in range(6):
		shoot_shotgun()
