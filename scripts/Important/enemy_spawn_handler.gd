extends Node

var timed_spawns = [false]

var time_elapsed = 0.0
func _process(delta: float):
	time_elapsed += delta
	
	if snapped(time_elapsed, 0.1) == 90:
		if timed_spawns[0] == false:
			spawn(enemies.get("Black slime"))
			timed_spawns[0] = true

var enemies = {
	"Green slime": preload("res://scenes/Enemy/green_slime.tscn"),
	"Blue slime": preload("res://scenes/Enemy/blue_slime.tscn"),
	"Red slime": preload("res://scenes/Enemy/red_slime.tscn"),
	"Black slime": preload("res://scenes/Enemy/black_slime.tscn")
	}
	
func spawn(mob):
	var new_mob = mob.instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)

func _wave_system_spacing():
	var enemy = []
	var wave = 0
	var selected = 0
	if time_elapsed < 30: #wave 1
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
			enemy.append(["Blue slime", 0.4])
		selected = 0
	elif time_elapsed < 80: #wave 3
		if wave == 2:
			enemy.clear()
			wave = 3
		if enemy.is_empty():
			enemy.append(["Green slime", 0.2])
			enemy.append(["Blue slime", 0.4])
		selected = randi_range(0, 1)	
	elif time_elapsed < 125:
		if wave == 3:
			enemy.clear()
			wave = 4
		if enemy.is_empty():
			enemy.append(["Green slime", 0.2])
			enemy.append(["Red slime", 0.65])
		selected = randi_range(0, 1)	
	elif time_elapsed < 160:
		if wave == 4:
			enemy.clear()
			wave = 5
		if enemy.is_empty():
			enemy.append(["Blue slime", 0.35])
			enemy.append(["Red slime", 0.65])
		selected = randi_range(0, 1)	
	elif time_elapsed < 240:
		if wave == 3:
			enemy.clear()
			wave = 4
		if enemy.is_empty():
			enemy.append(["Green slime", 0.15])
			enemy.append(["Blue slime", 0.3])
			enemy.append(["Red slime", 0.6])
		selected = randi_range(0, 2)	
	else:
		if enemy.is_empty():
			enemy.append(["Black slime", 1]) #end enemy(ies). They have unfair stats designed to end the game. Black slime is currently temporary.
		selected = 0
		print("your'e winer")
	spawn(enemies.get(enemy[selected][0]))
	$SpawnInterval.start(enemy[selected][1])	
	await $SpawnInterval.is_stopped()

func _ready():
	$SpawnInterval.start()
