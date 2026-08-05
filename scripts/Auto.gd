#Aim code#
extends Area2D

@onready var player = get_parent()

func get_player_damage():
	var player_damage = player.damage
	return player_damage

#if level is -1, then weapon is not yet unlocked.
var weapon_levels = DataTransfer.icons.duplicate(true)
var lantern = -1 #required

func _ready():
	weapon_levels = weapon_levels.slice(8, 21)

@warning_ignore("unused_parameter")
func _physics_process(delta):
	look_at(get_global_mouse_position())
	if lantern != weapon_levels[6][1]:
		lantern = weapon_levels[6][1]
		if %lantern.get_child(0):
			%lantern.get_child(0).queue_free()
		lantern_spawn()

#Weapon functions ==========================================================================

#Will explain how most of the functions work with this one. Will add additional comments to specific weapons with different code.
func shoot_pistol():
	#check if weapon is unlocked, otherwise ignores the whole script.
	if weapon_levels[0][1] != -1:
		#get the player's damage stat
		var weapon_damage = get_player_damage()
		
		#Sets the weapon's damage. Checks the weapon's level to increase the damage.
		if weapon_levels[0][1] == 0:
			weapon_damage = (weapon_damage * 1)
		elif weapon_levels[0][1] < 3:
			weapon_damage = (weapon_damage * 1) * 1.25
		elif weapon_levels[0][1] >= 3:
			weapon_damage = (weapon_damage * 1) * 1.5
		
		#Loading and spawning bullet/attack
		const BULLET = preload("res://scenes/Attacks/pistol_bullet.tscn")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation
		%ShootingPoint.add_child(new_bullet)
		new_bullet.projectile_damage = weapon_damage
		
		#Weapon cooldown. It exists because weapons can have their firerates reduced.
		if weapon_levels[0][1] < 2:
			%pistol.wait_time = 0.5
		elif weapon_levels[0][1] >= 2:
			%pistol.wait_time = (0.5 * 0.8)
	
func shoot_shotgun():
	if weapon_levels[1][1] != -1:
		var weapon_damage = get_player_damage()
		if weapon_levels[1][1] == 0:
			weapon_damage = (weapon_damage * 0.6)
		elif weapon_levels[1][1] >= 1:
			weapon_damage = (weapon_damage * 0.6) * 1.25
		const BULLET = preload("res://scenes/Attacks/shotgun_bullet.tscn")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		#shotgun and other 'inaccurate' weapons have a randomizing range for rotation, causing bullet to fly in different directions.
		new_bullet.global_rotation = %ShootingPoint.global_rotation + randf_range(-0.6, 0.6)
		%ShootingPoint.add_child(new_bullet)
		new_bullet.projectile_damage = weapon_damage
		
		if weapon_levels[1][1] < 2:
			%shotgun.wait_time = 1.5
		elif weapon_levels[1][1] >= 2:
			%shotgun.wait_time = (1.5 * 0.8)
	
func swing_sword():
	if weapon_levels[2][1] != -1:
		var weapon_damage = get_player_damage()
		if weapon_levels[2][1] == 0:
			weapon_damage = (weapon_damage * 1.5)
		elif weapon_levels[2][1] < 3:
			weapon_damage = (weapon_damage * 1.5) * 1.25
		elif weapon_levels[2][1] >= 3:
			weapon_damage = (weapon_damage * 1.5) * 1.5
			
		const BULLET = preload("res://scenes/Attacks/sword_slash.tscn")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation
		%ShootingPoint.add_child(new_bullet)
		new_bullet.projectile_damage = weapon_damage
		
		if weapon_levels[2][1] < 2:
			%sword.wait_time = 1.1
		elif weapon_levels[2][1] >= 2:
			%sword.wait_time = (1.1 * 0.8)

func fire_beam():
	if weapon_levels[3][1] != -1:
		var weapon_damage = get_player_damage()
		if weapon_levels[3][1] == 0:
			weapon_damage = (weapon_damage * 0.6)
		elif weapon_levels[3][1] >= 1:
			weapon_damage = (weapon_damage * 0.6) * 1.25
		var weapon_size = 1.0
		if weapon_levels[3][1] >= 3:
			weapon_size = 2.0
			
		const BULLET = preload("res://scenes/Attacks/beam.tscn")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation
		new_bullet.scale = Vector2(1.0, weapon_size)
		%ShootingPoint.add_child(new_bullet)
		new_bullet.projectile_damage = weapon_damage
		
		if weapon_levels[3][1] < 2:
			%beam.wait_time = 3.0
		elif weapon_levels[3][1] >= 2:
			%beam.wait_time = (3.0 * 0.8)

func shoot_sniper():
	if weapon_levels[4][1] != -1:
		var weapon_damage = get_player_damage()
		if weapon_levels[4][1] == 0:
			weapon_damage = (weapon_damage * 1.8)
		elif weapon_levels[4][1] >= 1:
			weapon_damage = (weapon_damage * 1.8) * 1.2
		
		#This value is for the amount of enemies the bullet can hit before disappearing. Levels effect the amount of piercing the sniper can do.
		var weapon_pierce = 5.0
		if weapon_levels[4][1] <= 2:
			weapon_pierce = 5.0
		elif weapon_levels[4][1] >= 3:
			weapon_pierce = 8.0
		
		const BULLET = preload("res://scenes/Attacks/sniper.tscn")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation
		%ShootingPoint.add_child(new_bullet)
		new_bullet.projectile_damage = weapon_damage
		new_bullet.pierce = weapon_pierce
		if weapon_levels[4][1] < 2:
			%sniper.wait_time = 3.25
		elif weapon_levels[4][1] >= 2:
			%sniper.wait_time = (3.25 * 0.8)

func shoot_gatlng():
	if weapon_levels[5][1] != -1:
		var weapon_damage = get_player_damage()
		if weapon_levels[5][1] == 0:
			weapon_damage = (weapon_damage * 0.3)
		elif weapon_levels[5][1] < 3:
			weapon_damage = (weapon_damage * 0.3) * 1.25
		elif weapon_levels[5][1] >= 3:
			weapon_damage = (weapon_damage * 0.3) * 1.5
		const BULLET = preload("res://scenes/Attacks/gatling.tscn")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation + randf_range(-0.125, 0.125)
		%ShootingPoint.add_child(new_bullet)
		new_bullet.projectile_damage = weapon_damage
		if weapon_levels[5][1] < 2:
			%gatling.wait_time = 0.2
		elif weapon_levels[5][1] >= 2:
			%gatling.wait_time = (0.2 * 0.75)

func lantern_spawn():
	if weapon_levels[6][1] != -1:
		var weapon_damage = get_player_damage()
		if weapon_levels[6][1] == 0:
			weapon_damage = (weapon_damage * 0.75)
		elif weapon_levels[6][1] >= 1:
			weapon_damage = (weapon_damage * 0.75) * 1.25
		
		const BULLET = preload("res://lantern.tscn")
		var new_bullet = BULLET.instantiate()
		
		#Checks for the orbiting pattern. If the node isn't in the current pattern, then it is removed via queue_free(). 
		if weapon_levels[6][1] < 3:
			new_bullet.get_child(2).queue_free()
			new_bullet.get_child(3).queue_free()
			new_bullet.get_child(4).queue_free()
		elif weapon_levels[6][1] >= 3:
			new_bullet.get_child(0).queue_free()
			new_bullet.get_child(1).queue_free()
		new_bullet.global_position = %ShootingPoint.global_position
		#Since the lantern itself rotates, the only thing it needs is a place where it can stay stationary. The %lantern node is for keeping the lantern in place.
		%lantern.add_child(new_bullet)
		new_bullet.projectile_damage = weapon_damage
		
		if weapon_levels[6][1] < 2:
			new_bullet.spin = 2.0
		elif weapon_levels[6][1] >= 2:
			new_bullet.spin = (2.0 * 1.25)

func sapper_sap():
	if weapon_levels[7][1] != -1:
		#Checks for any nodes existing in the collisionshape2d, otherwise does nothing.
		var overlapping_nodes = get_overlapping_bodies()
		if overlapping_nodes.is_empty():
			return null
		
		#Target is for locking onto the current target. Lowest_num is for storing which target has the lowest health.
		var target = null
		var lowest_num = INF
		
		var weapon_damage = get_player_damage()
		if weapon_levels[7][1] == 0:
			weapon_damage = (weapon_damage * 0.1)
		elif weapon_levels[7][1] >= 1:
			weapon_damage = (weapon_damage * 0.1) * 1.25
			
		const BULLET = preload("res://scenes/Attacks/sapper.tscn")
		var new_bullet = BULLET.instantiate()
		
		#Goes through all existing enemies in-range, storing the enemy with the lowest health in target and lowest_num variables.
		for enemies in overlapping_nodes:
			if enemies.health < lowest_num:
				lowest_num = enemies.health
				target = enemies
		#Gets the 2 points for where the line is created.
		if target and get_parent():
			new_bullet.points = [Vector2(0, 0), get_parent().to_local(target.global_position)]
		
		get_parent().add_child(new_bullet)
		target.take_damage(weapon_damage)
		
		if weapon_levels[7][1] < 2:
			%sapper.wait_time = 0.1
			new_bullet.firerate = 0.1
		elif weapon_levels[7][1] >= 2:
			%sapper.wait_time = (0.1 * 0.8)
			new_bullet.firerate = (0.1 * 0.8)

func volt_bolt():
	if weapon_levels[8][1] != -1:
		var overlapping_nodes = get_overlapping_bodies()
		if overlapping_nodes.is_empty():
			return null
		
		#Target self is here for the loop. previous_target stores all previous targets, so the loop can ignore them.
		var target = self
		var new_bullet = null
		var previous_target = []
		
		var weapon_damage = get_player_damage()
		if weapon_levels[8][1] == 0:
			weapon_damage = (weapon_damage * 0.5)
		elif weapon_levels[8][1] >= 1:
			weapon_damage = (weapon_damage * 0.5) * 1.25
		
		
		#This is for the chaining length. It is effected by levels.
		var chain_length = 5
		if weapon_levels[8][1] <= 2:
			chain_length = 4
		elif weapon_levels[8][1] >= 3:
			chain_length = 7
		
		const BULLET = preload("res://scenes/Attacks/volt.tscn")
		#Loops equal to the chain length.
		for i in range(chain_length):
			#Adds the previous target to the list and then clears the previous target. Target is needed outside this for loop, while nearest isn't, which is why nearest is assigned in here.
			previous_target.append(target)
			target = null
			var nearest = INF
			
			#Loops through all detected enemies. If the enemy being checked is in the previous_target list, then it is ignored.
			for enemies in overlapping_nodes:
				if not enemies in previous_target:
					#Gets the distance between the previous target and the current target. If the distance is shorter than the last check, then they are stored as the next target.
					var distance = previous_target[i].global_position.distance_to(enemies.global_position)
					if distance < nearest:
						nearest = distance
						target = enemies
			
			#Checks if the target isn't null and gets parent for the to_local. Most of this is the same as sapper, except it now gets the positions of the previous target instead. Also reduces the damage slightly every loop.
			if target and get_parent():
				new_bullet = BULLET.instantiate()
				new_bullet.points = [get_parent().to_local(previous_target[i].global_position), get_parent().to_local(target.global_position)]
				get_parent().add_child(new_bullet)
				target.take_damage(weapon_damage)
				weapon_damage *= 0.85
		
		if weapon_levels[8][1] < 2:
			%volt.wait_time = 1.0
			new_bullet.firerate = 0.1
		elif weapon_levels[8][1] >= 2:
			%volt.wait_time = (1.0 * 0.8)
			new_bullet.firerate = (0.1 * 0.8)

func fire_mortar():
	if weapon_levels[9][1] != -1:
		var weapon_damage = get_player_damage()
		if weapon_levels[9][1] == 0:
			weapon_damage = (weapon_damage * 2)
		elif weapon_levels[9][1] < 3:
			weapon_damage = (weapon_damage * 2) * 1.25
		elif weapon_levels[9][1] >= 3:
			weapon_damage = (weapon_damage * 2) * 1.5
		const BULLET = preload("res://scenes/Attacks/mortar.tscn")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = get_global_mouse_position()
		find_parent("Game").add_child(new_bullet)
		new_bullet.projectile_damage = weapon_damage
		if weapon_levels[9][1] < 2:
			%mortar.wait_time = 5.0
		elif weapon_levels[9][1] >= 2:
			%mortar.wait_time = (5.0 * 0.85)

func slash_dagger():
	if weapon_levels[10][1] != -1:
		var weapon_damage = get_player_damage()
		if weapon_levels[10][1] == 0:
			weapon_damage = (weapon_damage * 0.8)
		elif weapon_levels[10][1] < 3:
			weapon_damage = (weapon_damage * 0.8) * 1.25
		elif weapon_levels[10][1] >= 3:
			weapon_damage = (weapon_damage * 0.8) * 1.5
			
		const BULLET = preload("res://scenes/Attacks/dagger.tscn")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation
		%ShootingPoint.add_child(new_bullet)
		new_bullet.projectile_damage = weapon_damage
		
		if weapon_levels[10][1] < 2:
			%dagger.wait_time = 0.35
		elif weapon_levels[10][1] >= 2:
			%dagger.wait_time = (0.35 * 0.8)

func slash_katana():
	if weapon_levels[11][1] != -1:
		var weapon_damage = get_player_damage()
		if weapon_levels[11][1] == 0:
			weapon_damage = (weapon_damage * 1.25)
		elif weapon_levels[11][1] < 3:
			weapon_damage = (weapon_damage * 1.25) * 1.25
		elif weapon_levels[11][1] >= 3:
			weapon_damage = (weapon_damage * 1.25) * 1.5
			
		const BULLET = preload("res://scenes/Attacks/katana.tscn")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation
		%ShootingPoint.add_child(new_bullet)
		new_bullet.projectile_damage = weapon_damage
		
		if weapon_levels[11][1] < 2:
			%katana.wait_time = 2.5
		elif weapon_levels[11][1] >= 2:
			%katana.wait_time = (2.5 * 0.8)

func plant_mine():
	#check if weapon is unlocked, otherwise ignores the whole script.
	if weapon_levels[12][1] != -1:
		#get the player's damage stat
		var weapon_damage = get_player_damage()
		var level = weapon_levels[12][1]
		#Sets the weapon's damage. Checks the weapon's level to increase the damage.
		if level == 0:
			weapon_damage = (weapon_damage * 1)
		elif level >= 1:
			weapon_damage = (weapon_damage * 1) * 1.25
		
		#Loading and spawning bullet/attack
		const BULLET = preload("res://scenes/Attacks/mine.tscn")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShootingPoint.global_position
		new_bullet.global_rotation = %ShootingPoint.global_rotation + randf_range(3.6, -3.6)
		%ShootingPoint.add_child(new_bullet)
		new_bullet.projectile_damage = weapon_damage
		
		#Weapon cooldown. It exists because weapons can have their firerates reduced.
		if level < 2:
			%mine.wait_time = 1.8
		elif level >= 2:
			%mine.wait_time = (1.8 * 0.8)

#Weapon calling ============================================================================

func _on_pistol_timeout():
	shoot_pistol()
func _on_shotgun_timeout():
	if weapon_levels[1][1] < 3:
		for i in range(5):
			shoot_shotgun()
	elif weapon_levels[1][1] >= 3:
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
func _on_volt_timeout():
	volt_bolt()
func _on_mortar_timeout():
	fire_mortar()
func _on_dagger_timeout():
	slash_dagger()
func _on_katana_timeout():
	slash_katana()
func _on_mine_timeout():
	if weapon_levels[12][1] < 3:
		plant_mine()
	elif weapon_levels[12][1] >= 3:
		for i in range(2):
			plant_mine()
