extends Node

var win_time = 201

var timed_spawns = 0
@onready var path = %PathFollow2D

var enemies = {
	"Green slime": preload("res://scenes/Enemy/green_slime.tscn"),
	"Blue slime": preload("res://scenes/Enemy/blue_slime.tscn"),
	"Red slime": preload("res://scenes/Enemy/red_slime.tscn"),
	"Yellow slime": preload("res://scenes/Enemy/yellow_slime.tscn"),
	"Black slime": preload("res://scenes/Enemy/black_slime.tscn")
	}

func spawn(mob):
	if get_child_count() <= 154:
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
	
	if snapped_time == 45:
		if timed_spawns == 0:
			boss_spawn(enemies.get("Red slime"))
			timed_spawns = 1
	elif snapped_time == 120:
		if timed_spawns == 1:
			boss_spawn(enemies.get("Yellow slime"))
			timed_spawns = 2
	elif snapped_time >= 200:
		if timed_spawns == 2:
			boss_spawn(enemies.get("Black slime"))
			timed_spawns = 3

func _wave_system_spacing():
	var enemy = []
	var wave = 0
	var selected = 0
	if time_elapsed < 30: #wave 1
		if wave == 0:
			enemy.clear()
			wave = 1
		if enemy.is_empty():
			enemy.append(["Green slime", 0.6])
		selected = 0
	elif time_elapsed < 45: #wave 2
		if wave == 1:
			enemy.clear()
			wave = 2
		if enemy.is_empty():
			enemy.append(["Blue slime", 0.8])
		selected = 0
	elif time_elapsed < 75: #wave 3
		if wave == 2:
			enemy.clear()
			wave = 3
		if enemy.is_empty():
			enemy.append(["Green slime", 0.5])
			enemy.append(["Blue slime", 0.75])
		selected = randi_range(0, 1)	
	elif time_elapsed < 95:
		if wave == 3:
			enemy.clear()
			wave = 4
		if enemy.is_empty():
			enemy.append(["Green slime", 0.4])
			enemy.append(["Blue slime", 0.6])
		selected = randi_range(0, 1)	
	elif time_elapsed < 120:
		if wave == 4:
			enemy.clear()
			wave = 5
		if enemy.is_empty():
			enemy.append(["Blue slime", 0.55])
		selected = 0
	elif time_elapsed < 165:
		if wave == 3:
			enemy.clear()
			wave = 4
		if enemy.is_empty():
			for i in range(2):
				enemy.append(["Green slime", 0.4])
			enemy.append(["Red slime", 0.9])
		selected = randi_range(0, 2)
	elif time_elapsed < 200:
		if wave == 4:
			enemy.clear()
			wave = 5
		if enemy.is_empty():
			enemy.append(["Green slime", 0.3])
			enemy.append(["Blue slime", 0.5])
			enemy.append(["Red slime", 0.8])
		selected = randi_range(0, 2)	
	else:
		if enemy.is_empty():
			enemy.append(["Red slime", 0.65]) #end enemy(ies). They have unfair stats designed to end the game. Black slime is currently temporary.
		selected = 0
	spawn(enemies.get(enemy[selected][0]))
	$SpawnInterval.start(enemy[selected][1])	
	await $SpawnInterval.is_stopped()

func _ready():
	$SpawnInterval.start()
