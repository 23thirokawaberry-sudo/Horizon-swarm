extends Node

var win_time = 361
const ENEMY_APPEARENCES = ["Green slime", "Blue slime", "Red slime", "Black slime", "Tin robobot", "Copper robobot", "Steel robobot", "Blitzer", "Sandstone pillar"]

var timed_spawns = 0
@onready var path = %PathFollow2D
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
	if "boss" in new_mob:
		new_mob.boss = true
	path.progress_ratio = randf()
	new_mob.global_position = path.global_position
	$Boss.add_child(new_mob)
	var new_bar = BOSSBAR.instantiate()
	new_mob.add_child(new_bar)


var time_elapsed = 0.0
func _process(delta: float):
	time_elapsed += delta
	var snapped_time = snapped(time_elapsed, 0.1)
	
	if snapped_time == 35:
		if timed_spawns == 0:
			boss_spawn(enemies.get("Red slime"))
			timed_spawns = 1
	elif snapped_time == 100:
		if timed_spawns == 1:
			for i in range(3):
				boss_spawn(enemies.get("Red slime"))
			boss_spawn(enemies.get("Black slime"))
			timed_spawns = 2
	elif snapped_time == 185:
		if timed_spawns == 2:
			for i in range(3):
				boss_spawn(enemies.get("Black slime"))
			timed_spawns = 3
	elif snapped_time == 275:
		if timed_spawns == 3:
			for i in range(6):
				boss_spawn(enemies.get("Red slime"))
				boss_spawn(enemies.get("Copper robobot"))
			timed_spawns = 4
	elif snapped_time == 360:
		if timed_spawns == 4:
			for i in range(2):
				boss_spawn(enemies.get("Black slime"))
				boss_spawn(enemies.get("Steel robobot"))
			boss_spawn(enemies.get("Sandstone pillar"))
			timed_spawns = 5

func _wave_system_spacing():
	if time_elapsed < 30: #wave 1
		spawn([["Green slime", 1, 0.45]])
	elif time_elapsed < 50: #wave 2
		spawn([["Green slime", 8, 0.45], ["Sandstone pillar", 9, 0.6]])		
	elif time_elapsed < 85:
		spawn([["Green slime", 2, 0.4], ["Red slime", 3, 0.6], ["Tin robobot", 4, 1.0]])		
	elif time_elapsed < 110:
		spawn([["Tin robobot", 2, 0.8], ["Green slime", 3, 0.4]])	
	elif time_elapsed < 135:
		spawn([["Blue slime", 3, 0.5], ["Red slime", 5, 1.5], ["Tin robobot", 7, 0.85]])
	elif time_elapsed < 145:
		spawn([["Blue slime", 4, 0.45], ["Copper robobot", 6, 1.1], ["Sandstone pillar", 7, 0.6]])	
	elif time_elapsed < 148:
		spawn([["Sandstone pillar", 1, 0.5]])
	elif time_elapsed < 185:
		spawn([["Red slime", 1, 0.65]])
	elif time_elapsed < 210:
		spawn([["Red slime", 6, 0.6], ["Copper robobot", 11, 1.0], ["Sandstone pillar", 13, 0.6]])
	elif time_elapsed < 214:
		spawn([["Sandstone pillar", 1, 0.4]])
	elif time_elapsed < 216:
		spawn([["Blitzer", 1, 0.5]])
	elif time_elapsed < 222:
		spawn([["Green slime", 1, 2.5]])
	elif time_elapsed < 230:
		spawn([["Red slime", 1, 0.3]])
	elif time_elapsed < 275:
		spawn([["Red slime", 25, 0.55], ["Copper robobot", 50, 0.9], ["Blitzer", 51, 0.1], ["Sandstone pillar", 52, 0.1]])
	elif time_elapsed < 299:
		spawn([["Red slime", 22, 0.5], ["Copper robobot", 44, 0.8], ["Blitzer", 45, 0.1], ["Sandstone pillar", 46, 0.1]])
	elif time_elapsed < 300:
		spawn([["Blitzer", 1, 0.1], ["Sandstone pillar", 2, 0.1]])
	elif time_elapsed < 345:
		spawn([["Red slime", 20, 0.45], ["Copper robobot", 40, 0.8], ["Blitzer", 41, 0.1], ["Sandstone pillar", 42, 0.1]])
	elif time_elapsed < 360:
		spawn([["Black slime", 1, 3.5], ["Steel robobot", 2, 3.5]])
	else:
		spawn([["Blitzer", 1, 3.5], ["Sandstone pillar", 2, 3.5]])
		spawn([["Black slime", 1, 3.5], ["Steel robobot", 2, 3.5]])

func _ready():
	$SpawnInterval.start()
