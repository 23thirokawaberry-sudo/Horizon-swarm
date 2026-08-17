extends Node

var win_time = 261
const ENEMY_APPEARENCES = ["Green slime", "Blue slime", "Black slime", "Tarnished purple", "Tin robobot"]

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
			boss_spawn(enemies.get("Tarnished purple"))
			timed_spawns = 1
	elif snapped_time == 180:
		if timed_spawns == 1:
			boss_spawn(enemies.get("Black slime"))
			timed_spawns = 2
	elif snapped_time == 260:
		if timed_spawns == 2:
			for i in range(2):
				boss_spawn(enemies.get("Black slime")) #Change to 1 turquoize tarnished when added
			timed_spawns = 3

func _wave_system_spacing():
	if time_elapsed < 25: #wave 1
		spawn([["Green slime", 1, 0.65]])
	elif time_elapsed < 60: #wave 2
		spawn([["Green slime", 2, 0.65], ["Blue slime", 3, 0.95]])
	elif time_elapsed < 70: #wave 3
		spawn([["Tin robobot", 1, 0.8]])
	elif time_elapsed < 90:
		spawn([["Green slime", 1, 0.6], ["Blue slime", 2, 0.85]])
	elif time_elapsed < 120:
		spawn([["Blue slime", 2, 0.85], ["Tin robobot", 3, 0.9]])
	elif time_elapsed < 125:
		spawn([["Green slime", 1, 0.3]])
	elif time_elapsed < 165:
		spawn([["Green slime", 2, 0.55], ["Blue slime", 4, 0.8], ["Tin robobot", 5, 0.8]])
	elif time_elapsed < 180:
		spawn([["Tarnished purple", 1, 2.0]])
	elif time_elapsed < 215:
		spawn([["Tin robobot", 2, 0.75], ["Tarnished purple", 3, 2.0]])
	elif time_elapsed < 260:
		spawn([["Green slime", 4, 0.5], ["Blue slime", 8, 0.75], ["Tin robobot", 11, 0.75], ["Tarnished purple", 13, 1.75]])
	else:
		spawn([["Tarnished purple", 1, 1.6]])

func _ready():
	$SpawnInterval.start()
