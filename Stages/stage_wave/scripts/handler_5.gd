extends Node

var win_time = 161

var timed_spawns = 0
@onready var paths = [%PathFollow2D, %PathFollow2D2, %PathFollow2D3, %PathFollow2D4]

var enemies = {
	"Green slime": preload("res://scenes/Enemy/green_slime.tscn"),
	"Blue slime": preload("res://scenes/Enemy/blue_slime.tscn"),
	"Red slime": preload("res://scenes/Enemy/red_slime.tscn"),
	"Tarnished purple": preload("res://scenes/Enemy/tarnished_purple.tscn")
	}

func spawn(mob):
	if get_child_count() <= 153:
		var new_mob = mob.instantiate()
		var path = paths.pick_random()
		path.progress_ratio = randf()
		new_mob.global_position = path.global_position
		add_child(new_mob)

func boss_spawn(mob):
	var new_mob = mob.instantiate()
	new_mob.health *= 5
	new_mob.max_health *= 5
	new_mob.damage *= 2.25
	new_mob.scale *= 1.5
	if "boss" in new_mob:
		new_mob.boss = true
	var path = paths.pick_random()
	path.progress_ratio = randf()
	new_mob.global_position = path.global_position
	$Boss.add_child(new_mob)

var time_elapsed = 0.0
func _process(delta: float):
	time_elapsed += delta
	var snapped_time = snapped(time_elapsed, 0.1)
	
	if snapped_time == 160:
		if timed_spawns == 0:
			boss_spawn(enemies.get("Tarnished purple"))
			timed_spawns = 1

func _wave_system_spacing():
	var enemy = []
	var wave = 0
	var selected = 0
	if time_elapsed < 25: #wave 1
		if wave == 0:
			enemy.clear()
			wave = 1
		if enemy.is_empty():
			enemy.append(["Green slime", 1.25])
		selected = 0
	elif time_elapsed < 36: #wave 2
		if wave == 1:
			enemy.clear()
			wave = 2
		if enemy.is_empty():
			enemy.append(["Green slime", 1.2])
			enemy.append(["Blue slime", 1.5])
		selected = randi_range(0, 1)
	elif time_elapsed < 45: #wave 3
		if wave == 2:
			enemy.clear()
			wave = 3
		if enemy.is_empty():
			enemy.append(["Blue slime", 1.4])
		selected = 0
	elif time_elapsed < 65:
		if wave == 3:
			enemy.clear()
			wave = 4
		if enemy.is_empty():
			enemy.append(["Green slime", 1.05])
			enemy.append(["Blue slime", 1.35])
		selected = randi_range(0, 1)	
	elif time_elapsed < 80:
		if wave == 4:
			enemy.clear()
			wave = 5
		if enemy.is_empty():
			for i in range(2):
				enemy.append(["Green slime", 1.0])
			enemy.append(["Red slime", 3.0])
		selected = randi_range(0, 2)	
	elif time_elapsed < 100:
		if wave == 3:
			enemy.clear()
			wave = 4
		if enemy.is_empty():
			enemy.append(["Blue slime", 1.25])
		selected = 0
	elif time_elapsed < 110:
		if wave == 4:
			enemy.clear()
			wave = 5
		if enemy.is_empty():
			for i in range(2):
				enemy.append(["Blue slime", 1.25])
				enemy.append(["Green slime", 0.95])
			enemy.append(["Red slime", 1.55])
		selected = randi_range(0, 4)
	elif time_elapsed < 135:
		if wave == 5:
			enemy.clear()
			wave = 6
		if enemy.is_empty():
			enemy.append(["Red slime", 2.0])
		selected = 0
	elif time_elapsed < 145:
		if wave == 6:
			enemy.clear()
			wave = 7
		if enemy.is_empty():
			enemy.append(["Red slime", 1.8])
			enemy.append(["Blue slime", 1.2])
		selected = randi_range(0, 1)
	elif time_elapsed < 160:
		if wave == 7:
			enemy.clear()
			wave = 8
		if enemy.is_empty():
			enemy.append(["Red slime", 1.8])
			enemy.append(["Green slime", 0.8])
			enemy.append(["Blue slime", 1.2])
		selected = randi_range(0, 2)
	else:
		if enemy.is_empty():
			for i in range(2):
				enemy.append(["Green slime", 0.65])
			enemy.append(["Blue slime", 1.1])
		selected = randi_range(0, 2)
	spawn(enemies.get(enemy[selected][0]))
	$SpawnInterval.start(enemy[selected][1])	
	await $SpawnInterval.is_stopped()

func _ready():
	$SpawnInterval.start()
