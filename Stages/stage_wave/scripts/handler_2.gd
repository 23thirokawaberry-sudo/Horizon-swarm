extends Node

var timed_spawns = 0
@onready var path = get_parent().find_child("Player").find_child("Path2D").find_child("PathFollow2D")

var enemies = {
	"Green slime": preload("res://scenes/Enemy/green_slime.tscn"),
	"Blue slime": preload("res://scenes/Enemy/blue_slime.tscn"),
	"Red slime": preload("res://scenes/Enemy/red_slime.tscn"),
	"Black slime": preload("res://scenes/Enemy/black_slime.tscn"),
	"Triangle mage": preload("res://scenes/Enemy/triangle_mage.tscn"),
	"Tarnished purple": preload("res://scenes/Enemy/tarnished_purple.tscn"),
	"Robobot": preload("res://scenes/Enemy/robobot.tscn")
	}

func spawn(mob):
	if get_child_count() <= 150:
		var new_mob = mob.instantiate()
		path.progress_ratio = randf()
		new_mob.global_position = path.global_position
		add_child(new_mob)


var time_elapsed = 0.0
func _process(delta: float):
	time_elapsed += delta
	var snapped_time = snapped(time_elapsed, 0.1)
	
	if snapped_time == 90:
		if timed_spawns == 0:
			for i in range(5):
				spawn(enemies.get("Triangle mage"))
			timed_spawns = 1
	elif snapped_time == 180:
		if timed_spawns == 1:
			for i in range(15):
				spawn(enemies.get("Triangle mage"))
			timed_spawns = 2
	elif snapped_time == 300:
		if timed_spawns == 2:
			for i in range(30):
				spawn(enemies.get("Triangle mage"))
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
			enemy.append(["Green slime", 0.25])
		selected = 0
	elif time_elapsed < 60: #wave 2
		if wave == 1:
			enemy.clear()
			wave = 2
		if enemy.is_empty():
			enemy.append(["Green slime", 0.4])
			enemy.append(["Blue slime", 0.4])
		selected = randi_range(0, 1)
	elif time_elapsed < 90: #wave 3
		if wave == 2:
			enemy.clear()
			wave = 3
		if enemy.is_empty():
			enemy.append(["Robobot", 0.75])
	elif time_elapsed < 140:
		if wave == 3:
			enemy.clear()
			wave = 4
		if enemy.is_empty():
			enemy.append(["Robobot", 0.5])
			enemy.append(["Tarnished purple", 0.65])
		selected = randi_range(0, 1)	
	elif time_elapsed < 190:
		if wave == 4:
			enemy.clear()
			wave = 5
		if enemy.is_empty():
			enemy.append(["Blue slime", 0.35])
			enemy.append(["Robobot", 0.4])
			enemy.append(["Tarnished purple", 0.65])
		selected = randi_range(0, 2)	
	elif time_elapsed < 200:
		if wave == 3:
			enemy.clear()
			wave = 4
		if enemy.is_empty():
			enemy.append(["Green slime", 0.05])
		selected = 0
	elif time_elapsed < 260:
		if wave == 4:
			enemy.clear()
			wave = 5
		if enemy.is_empty():
			enemy.append(["Robobot", 0.3])
			enemy.append(["Blue slime", 0.2])
			enemy.append(["Red slime", 0.3])
		selected = randi_range(0, 2)	
	elif time_elapsed < 360:
		if wave == 4:
			enemy.clear()
			wave = 5
		if enemy.is_empty():
			for i in range(5):
				enemy.append(["Robobot", 0.2])
				enemy.append(["Blue slime", 0.1])
				enemy.append(["Red slime", 0.2])
			enemy.append(["Black slime", 0.5])
		selected = randi_range(0, 15)	
	else:
		if enemy.is_empty():
			enemy.append(["Black slime", 0.1]) #end enemy(ies). They have unfair stats designed to end the game. Black slime is currently temporary.
		selected = 0
		print("your'e winer")
	spawn(enemies.get(enemy[selected][0]))
	$SpawnInterval.start(enemy[selected][1])	
	await $SpawnInterval.is_stopped()

func _ready():
	$SpawnInterval.start()
