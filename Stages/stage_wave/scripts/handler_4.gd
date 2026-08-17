extends Node

var win_time = 321
const ENEMY_APPEARENCES = ["Green slime", "Red slime", "Black slime", "Tarnished purple", "Tarnished turquoize", "Triangle mage"]

var timed_spawns = 0
@onready var paths = [%PathFollow2D, %PathFollow2D2]

const WEAPON_UNLOCK = ["Lantern", "Sapper", "Volt"]

@onready var enemies = get_parent().ENEMIES

func spawn(mobs):
	if get_child_count() <= 154:
		print(mobs)		
		var selected = randi_range(0, mobs[-1][1])
		var new_mob = null
		for mob in mobs:
			print(mob)
			if mob[1] >= selected:
				new_mob = mob[0]
				print(new_mob)
				$SpawnInterval.wait_time = mob[2]
				break
		var spawn_mob = enemies.get(new_mob).instantiate()
		var path = paths.pick_random()
		path.progress_ratio = randf()
		spawn_mob.global_position = path.global_position
		add_child(spawn_mob)
		$SpawnInterval.start()
	else:
		get_child(4).queue_free()

func boss_spawn(mob):
	const BOSSBAR = preload("res://scenes/Important/boss_bar.tscn")
	var new_mob = mob.instantiate()
	new_mob.health *= 5
	new_mob.max_health *= 5
	new_mob.damage *= 2.25
	new_mob.scale *= 1.5
	var path = paths.pick_random()
	path.progress_ratio = randf()
	new_mob.global_position = path.global_position
	$Boss.add_child(new_mob)
	var new_bar = BOSSBAR.instantiate()
	new_mob.add_child(new_bar)


var time_elapsed = 0.0
func _process(delta: float):
	time_elapsed += delta
	var snapped_time = snapped(time_elapsed, 0.1)
	
	if snapped_time == 75:
		if timed_spawns == 0:
			boss_spawn(enemies.get("Tarnished purple"))
			timed_spawns = 1
	elif snapped_time == 145:
		if timed_spawns == 1:
			for i in range(3):
				boss_spawn(enemies.get("Triangle mage"))
			timed_spawns = 2
	elif snapped_time == 220:
		if timed_spawns == 2:
			for i in range(3):
				boss_spawn(enemies.get("Black slime"))
			timed_spawns = 3
	elif snapped_time == 320:
		if timed_spawns == 3:
			for i in range(5):
				boss_spawn(enemies.get("Black slime"))
				boss_spawn(enemies.get("Triangle mage"))
			timed_spawns = 4

func _wave_system_spacing():
	if time_elapsed < 30: #wave 1
		spawn([["Green slime", 1, 0.45]])
	elif time_elapsed < 60: #wave 2
		spawn([["Green slime", 3, 0.4], ["Red slime", 4, 0.8]])	
	elif time_elapsed < 90: #wave 3
		spawn([["Tarnished purple", 1, 0.85]])
	elif time_elapsed < 150:
		spawn([["Green slime", 2, 0.35], ["Red slime", 3, 0.7]])		
	elif time_elapsed < 175:
		spawn([["Green slime", 7, 0.4], ["Red slime", 13, 0.7], ["Triangle mage", 15, 0.8]])	
	elif time_elapsed < 180:
		spawn([["Triangle mage", 1, 0.5]])	
	elif time_elapsed < 220:
		spawn([["Green slime", 3, 0.3], ["Red slime", 6, 0.65], ["Tarnished purple", 8, 0.75], ["Triangle mage", 9, 1.0]])
	elif time_elapsed < 265:
		spawn([["Green slime", 3, 0.3], ["Tarnished purple", 5, 0.7]])
	elif time_elapsed < 300:
		spawn([["Red slime", 4, 0.6], ["Tarnished purple", 7, 0.65], ["Triangle mage", 8, 1.0]])
	elif time_elapsed < 320:
		spawn([["Green slime", 2, 0.25], ["Red slime", 5, 0.55], ["Tarnished purple", 8, 0.6], ["Triangle mage", 10, 1.0]])
	else:
		spawn([["Red slime", 7, 0.5], ["Triangle mage", 9, 0.8]])
	await $SpawnInterval.is_stopped()

func _ready():
	$SpawnInterval.start()
