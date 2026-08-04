extends Node

var win_time = 361

var time_elapsed = 0.0
var overflowed_enemies = 0
var timed_spawns = 0
@onready var path = %PathFollow2D

var enemies = {
	"Green slime": preload("res://scenes/Enemy/green_slime.tscn"),
	"Yellow slime": preload("res://scenes/Enemy/yellow_slime.tscn"),
	"Black slime": preload("res://scenes/Enemy/black_slime.tscn"),
	"Tin robobot": preload("res://scenes/Enemy/robobot.tscn"),
	"Copper robobot": preload("res://scenes/Enemy/copper_robobot.tscn"),
	"Steel robobot": preload("res://scenes/Enemy/steel_robobot.tscn"),
	"Bluesteel robobot": preload("res://scenes/Enemy/bluesteel_robobot.tscn"),
	"Triangle mage": preload("res://scenes/Enemy/triangle_mage.tscn"),
	"Blitzer": preload("res://scenes/Enemy/blitzer.tscn")
	}

func spawn(mob):
	if get_child_count() <= 228:
		var new_mob = mob.instantiate()
		path.progress_ratio = randf()
		new_mob.global_position = path.global_position
		add_child(new_mob)
	else:
		get_child(4).queue_free()
		overflowed_enemies += 1

func boss_spawn(mob):
	var new_mob = mob.instantiate()
	new_mob.health *= 5
	new_mob.max_health *= 5
	new_mob.damage *= 2.25
	new_mob.scale *= 1.5
	path.progress_ratio = randf()
	new_mob.global_position = path.global_position
	$Boss.add_child(new_mob)

func _process(delta: float):
	time_elapsed += delta
	var snapped_time = snapped(time_elapsed, 0.1)
	
	if snapped_time == 60:
		if timed_spawns == 0:
			for i in range(3):
				boss_spawn(enemies.get("Yellow slime"))
			boss_spawn(enemies.get("Black slime"))
			timed_spawns = 1
	elif snapped_time == 125:
		if timed_spawns == 1:
			for i in range(2):
				boss_spawn(enemies.get("Black slime"))
			boss_spawn(enemies.get("Blitzer"))
			timed_spawns = 2
	elif snapped_time == 200:
		if timed_spawns == 2:
			for i in range(3):
				boss_spawn(enemies.get("Black slime"))
			boss_spawn(enemies.get("Steel robobot"))
			timed_spawns = 3
	elif snapped_time == 285:
		if timed_spawns == 3:
			for i in range(10):
				boss_spawn(enemies.get("Triangle mage"))
			boss_spawn(enemies.get("Black slime"))
			boss_spawn(enemies.get("Blitzer"))
			boss_spawn(enemies.get("Steel robobot"))
			timed_spawns = 4
	elif snapped_time == 360:
		if timed_spawns == 4:
			boss_spawn(enemies.get("Bluesteel robobot"))
			timed_spawns = 5

func _wave_system_spacing():
	var enemy = []
	var wave = 0
	var selected = 0
	if time_elapsed < 25: #wave 1
		if wave == 0:
			enemy.clear()
			wave = 1
		if enemy.is_empty():
			enemy.append(["Green slime", 0.2])
		selected = 0
	elif time_elapsed < 45: #wave 2
		if wave == 1:
			enemy.clear()
			wave = 2
		if enemy.is_empty():
			enemy.append(["Tin robobot", 0.45])
		selected = 0
	elif time_elapsed < 65: #wave 3
		if wave == 2:
			enemy.clear()
			wave = 3
		if enemy.is_empty():
			enemy.append(["Tin robobot", 0.45])
			enemy.append(["Green slime", 0.2])
		selected = randi_range(0, 1)
	elif time_elapsed < 80:
		if wave == 3:
			enemy.clear()
			wave = 4
		if enemy.is_empty():
			enemy.append(["Tin robobot", 0.4])
			enemy.append(["Yellow slime", 0.6])
		selected = randi_range(0, 1)
	elif time_elapsed < 95:
		if wave == 4:
			enemy.clear()
			wave = 5
		if enemy.is_empty():
			enemy.append(["Yellow slime", 0.6])
			print(enemy)
		selected = 0
	elif time_elapsed < 125:
		if wave == 5:
			enemy.clear()
			wave = 6
		if enemy.is_empty():
			for i in range(2):
				enemy.append(["Tin robobot", 0.4])
			enemy.append(["Copper robobot", 0.6])
		selected = randi_range(0, 2)
	elif time_elapsed < 150:
		if wave == 6:
			enemy.clear()
			wave = 7
		if enemy.is_empty():
			enemy.append(["Tin robobot", 0.3])
			enemy.append(["Copper robobot", 0.5])
			enemy.append(["Green slime", 0.1])
		selected = randi_range(0, 2)
	elif time_elapsed < 165:
		if wave == 7:
			enemy.clear()
			wave = 8
		if enemy.is_empty():
			enemy.append(["Copper robobot", 0.5])
		selected = 0
	elif time_elapsed < 200:
		if wave == 8:
			enemy.clear()
			wave = 9
		if enemy.is_empty():
			for i in range(8):
				enemy.append(["Yellow slime", 0.25])
				enemy.append(["Tin robobot", 0.25])
			enemy.append(["Blitzer", 1.0])
		selected = randi_range(0, 16)
	elif time_elapsed < 208:
		if wave == 9:
			enemy.clear()
			wave = 10
		if enemy.is_empty():
			enemy.append(["Triangle mage", 0.3])
		selected = 0
	elif time_elapsed < 240:
		if wave == 10:
			enemy.clear()
			wave = 11
		if enemy.is_empty():
			for i in range(4):
				for ii in range(3):
					enemy.append(["Copper robobot", 0.45])
				enemy.append(["Triangle mage", 0.35])
			enemy.append(["Blitzer", 0.8])
		selected = randi_range(0, 16)
	elif time_elapsed < 285:
		if wave == 11:
			enemy.clear()
			wave = 12
		if enemy.is_empty():
			enemy.append(["Tin robobot", 0.2])
			enemy.append(["Copper robobot", 0.4])
			enemy.append(["Steel robobot", 1.0])
		selected = randi_range(0, 2)
	elif time_elapsed < 320:
		if wave == 12:
			enemy.clear()
			wave = 13
		if enemy.is_empty():
			for i in range(10):
				enemy.append(["Copper robobot", 0.35])
			enemy.append(["Steel robobot", 0.65])
			enemy.append(["Blitzer", 0.75])
		selected = randi_range(0, 11)
	elif time_elapsed < 360:
		if wave == 13:
			enemy.clear()
			wave = 14
		if enemy.is_empty():
			for i in range(6):
				enemy.append(["Steel robobot", 0.7])
			enemy.append(["Blitzer", 1.0])
		selected = randi_range(0, 6)
	else:
		if enemy.is_empty():
			enemy.append(["Copper robobot", 0.2])
		selected = 0
	spawn(enemies.get(enemy[selected][0]))
	$SpawnInterval.start(enemy[selected][1])	
	await $SpawnInterval.is_stopped()

func _ready():
	$SpawnInterval.start()
