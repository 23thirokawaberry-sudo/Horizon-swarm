extends Node

var win_time = 281
const ENEMY_APPEARENCES = ["Blue slime", "Red slime", "Yellow slime", "Tarnished turquoize", "Tin robobot", "Copper robobot", "Triangle mage", "Blitzer"]
const WEAPON_UNLOCK = ["Mortar"]

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
	
	if snapped_time == 90:
		if timed_spawns == 0:
			boss_spawn(enemies.get("Yellow slime"))
			timed_spawns = 1
	elif snapped_time == 120:
		if timed_spawns == 1:
			for i in range(2):
				boss_spawn(enemies.get("Copper robobot"))
			timed_spawns = 2
	elif snapped_time == 280:
		if timed_spawns == 2:
			boss_spawn(enemies.get("Tarnished turquoize"))
			for i in range(3):
				boss_spawn(enemies.get("Copper robobot"))
				boss_spawn(enemies.get("Triangle mage"))
			timed_spawns = 3

func _wave_system_spacing():
	if time_elapsed < 20: #wave 1
		spawn([["Blue slime", 1, 0.75]])
	elif time_elapsed < 45: #wave 2
		spawn([["Blue slime", 2, 0.7], ["Red slime", 3, 0.9]])		
	elif time_elapsed < 90:
		spawn([["Blue slime", 2, 0.6], ["Red slime", 3, 0.75], ["Tin robobot", 4, 1.0]])		
	elif time_elapsed < 120:
		spawn([["Tin robobot", 6, 0.9], ["Triangle mage", 7, 1.8]])	
	elif time_elapsed < 150:
		spawn([["Red slime", 3, 0.7], ["Yellow slime", 5, 1.5], ["Tin robobot", 8, 0.85]])
	elif time_elapsed < 205:
		spawn([["Blue slime", 1, 0.1], ["Tin robobot", 7, 0.85], ["Copper robobot", 9, 1.25]])	
	elif time_elapsed < 240:
		spawn([["Yellow slime", 30, 1.35], ["Copper robobot", 50, 1.1], ["Blitzer", 51, 0.1]])
	elif time_elapsed < 280:
		spawn([["Yellow slime", 28, 1.25], ["Copper robobot", 52, 1.0], ["Triangle mage", 60, 1.0], ["Blitzer", 62, 0.1]])
	else:
		spawn([["Yellow slime", 20, 1.15], ["Copper robobot", 40, 0.9], ["Blitzer", 42, 0.1]])

func _ready():
	$SpawnInterval.start()
