extends Node

var win_time = 301

var timed_spawns = 0
@onready var path = %PathFollow2D

var enemies = {
	"Green slime": preload("res://scenes/Enemy/green_slime.tscn"),
	"Blue slime": preload("res://scenes/Enemy/blue_slime.tscn"),
	"Black slime": preload("res://scenes/Enemy/black_slime.tscn"),
	"Tarnished purple": preload("res://scenes/Enemy/tarnished_purple.tscn"),
	"Robobot": preload("res://scenes/Enemy/robobot.tscn")
	}

func spawn(mob):
	if get_child_count() <= 153:
		var new_mob = mob.instantiate()
		path.progress_ratio = randf()
		new_mob.global_position = path.global_position
		add_child(new_mob)

func boss_spawn(mob):
	var new_mob = mob.instantiate()
	new_mob.health *= 5
	new_mob.max_health *= 5
	new_mob.damage *= 2.25
	new_mob.scale *= 1.5
	path.progress_ratio = randf()
	new_mob.global_position = path.global_position
	$Boss.add_child(new_mob)

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
			for i in range(2):
				boss_spawn(enemies.get("Black slime"))
			timed_spawns = 2
	elif snapped_time == 300:
		if timed_spawns == 2:
			for i in range(5):
				boss_spawn(enemies.get("Black slime")) #Change to 1 turquoize tarnished when added
			timed_spawns = 3

func _wave_system_spacing():
	var enemy = []
	var wave = 0
	var selected = 0
	if time_elapsed < 25: #wave 1
		if wave == 0:
			enemy.clear()
			wave = 1
		if enemy.is_empty():
			enemy.append(["Green slime", 0.5])
		selected = 0
	elif time_elapsed < 60: #wave 2
		if wave == 1:
			enemy.clear()
			wave = 2
		if enemy.is_empty():
			enemy.append(["Green slime", 0.4])
			enemy.append(["Blue slime", 0.6])
		selected = randi_range(0, 1)
	elif time_elapsed < 70: #wave 3
		if wave == 2:
			enemy.clear()
			wave = 3
		if enemy.is_empty():
			enemy.append(["Robobot", 0.75])
		selected = 0
	elif time_elapsed < 90:
		if wave == 3:
			enemy.clear()
			wave = 4
		if enemy.is_empty():
			enemy.append(["Green slime", 0.35])
			enemy.append(["Blue slime", 0.5])
		selected = randi_range(0, 1)	
	elif time_elapsed < 120:
		if wave == 4:
			enemy.clear()
			wave = 5
		if enemy.is_empty():
			enemy.append(["Blue slime", 0.4])
			enemy.append(["Robobot", 0.7])
		selected = randi_range(0, 1)	
	elif time_elapsed < 125:
		if wave == 3:
			enemy.clear()
			wave = 4
		if enemy.is_empty():
			enemy.append(["Green slime", 0.15])
		selected = 0
	elif time_elapsed < 165:
		if wave == 4:
			enemy.clear()
			wave = 5
		if enemy.is_empty():
			enemy.append(["Robobot", 0.65])
			enemy.append(["Blue slime", 0.45])
			enemy.append(["Green slime", 0.3])
		selected = randi_range(0, 2)
	elif time_elapsed < 180:
		if wave == 5:
			enemy.clear()
			wave = 6
		if enemy.is_empty():
			enemy.append(["Tarnished purple", 1.0])
		selected = 0
	elif time_elapsed < 215:
		if wave == 6:
			enemy.clear()
			wave = 7
		if enemy.is_empty():
			enemy.append(["Robobot", 0.6])
			enemy.append(["Tarnished purple", 1.0])
		selected = randi_range(0, 1)
	elif time_elapsed < 275:
		if wave == 7:
			enemy.clear()
			wave = 8
		if enemy.is_empty():
			enemy.append(["Robobot", 0.6])
			enemy.append(["Blue slime", 0.35])
			enemy.append(["Green slime", 0.2])
			enemy.append(["Tarnished purple", 0.9])
		selected = randi_range(0, 3)
	elif time_elapsed < 300:
		if wave == 8:
			enemy.clear()
			wave = 9
		if enemy.is_empty():
			for i in range(8): #First instance of this. This makes all enemies in the loop more likely to spawn compared to the enemies outside the loop.
				enemy.append(["Robobot", 0.55])
				enemy.append(["Blue slime", 0.3])
				enemy.append(["Green slime", 0.2])
			enemy.append(["Black slime", 1.25])
		selected = randi_range(0, 24)	
	else:
		if enemy.is_empty():
			enemy.append(["Tarnished purple", 0.825])
		selected = 0
		print("your'e winer")
	spawn(enemies.get(enemy[selected][0]))
	$SpawnInterval.start(enemy[selected][1])	
	await $SpawnInterval.is_stopped()

func _ready():
	$SpawnInterval.start()
