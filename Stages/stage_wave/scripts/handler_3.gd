extends Node

var win_time = 321

var timed_spawns = 0
@onready var paths = [%PathFollow2D, %PathFollow2D2]

const WEAPON_UNLOCK = ["Lantern", "Sapper", "Volt"]

var enemies = {
	"Green slime": preload("res://scenes/Enemy/green_slime.tscn"),
	"Red slime": preload("res://scenes/Enemy/red_slime.tscn"),
	"Black slime": preload("res://scenes/Enemy/black_slime.tscn"),
	"Tarnished purple": preload("res://scenes/Enemy/tarnished_purple.tscn"),
	"Triangle mage": preload("res://scenes/Enemy/triangle_mage.tscn")
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
	var enemy = []
	var wave = 0
	var selected = 0
	if time_elapsed < 30: #wave 1
		if wave == 0:
			enemy.clear()
			wave = 1
		if enemy.is_empty():
			enemy.append(["Green slime", 0.45])
		selected = 0
	elif time_elapsed < 60: #wave 2
		if wave == 1:
			enemy.clear()
			wave = 2
		if enemy.is_empty():
			enemy.append(["Green slime", 0.4])
			enemy.append(["Red slime", 0.8])
		selected = randi_range(0, 1)
	elif time_elapsed < 90: #wave 3
		if wave == 2:
			enemy.clear()
			wave = 3
		if enemy.is_empty():
			enemy.append(["Tarnished purple", 0.75])
		selected = 0
	elif time_elapsed < 150:
		if wave == 3:
			enemy.clear()
			wave = 4
		if enemy.is_empty():
			enemy.append(["Green slime", 0.35])
			enemy.append(["Red slime", 0.5])
		selected = randi_range(0, 1)	
	elif time_elapsed < 175:
		if wave == 4:
			enemy.clear()
			wave = 5
		if enemy.is_empty():
			for i in range(3):
				enemy.append(["Green slime", 0.4])
				enemy.append(["Red slime", 0.7])
			enemy.append(["Triangle mage", 1.0])
		selected = randi_range(0, 6)	
	elif time_elapsed < 180:
		if wave == 3:
			enemy.clear()
			wave = 4
		if enemy.is_empty():
			enemy.append(["Triangle mage", 0.4])
		selected = 0
	elif time_elapsed < 220:
		if wave == 4:
			enemy.clear()
			wave = 5
		if enemy.is_empty():
			for i in range(2):
				enemy.append(["Tarnished purple", 0.65])
				enemy.append(["Red slime", 0.6])
				enemy.append(["Green slime", 0.3])
			enemy.append(["Triangle mage", 0.8])
		selected = randi_range(0, 6)
	elif time_elapsed < 265:
		if wave == 5:
			enemy.clear()
			wave = 6
		if enemy.is_empty():
			enemy.append(["Tarnished purple", 0.6])
			enemy.append(["Green slime", 0.2])
		selected = randi_range(0, 1)
	elif time_elapsed < 300:
		if wave == 6:
			enemy.clear()
			wave = 7
		if enemy.is_empty():
			enemy.append(["Red slime", 0.5])
			enemy.append(["Tarnished purple", 0.6])
			enemy.append(["Triangle mage", 0.8])
		selected = randi_range(0, 2)
	elif time_elapsed < 320:
		if wave == 7:
			enemy.clear()
			wave = 8
		if enemy.is_empty():
			enemy.append(["Triangle mage", 0.75])
			enemy.append(["Red slime", 0.45])
			enemy.append(["Green slime", 0.15])
			enemy.append(["Tarnished purple", 0.55])
		selected = randi_range(0, 3)
	else:
		if enemy.is_empty():
			for i in range(3):
				enemy.append(["Triangle mage", 0.7])
			enemy.append(["Black slime", 1.2])
		selected = randi_range(0, 3)
	spawn(enemies.get(enemy[selected][0]))
	$SpawnInterval.start(enemy[selected][1])	
	await $SpawnInterval.is_stopped()

func _ready():
	$SpawnInterval.start()
