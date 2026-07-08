extends Node

var win_time = 241

var overflowed_enemies = 0
var timed_spawns = 0
@onready var path = get_parent().find_child("Player").find_child("Path2D").find_child("PathFollow2D")

var enemies = {
	"Green slime": preload("res://scenes/Enemy/green_slime.tscn"),
	"Blue slime": preload("res://scenes/Enemy/blue_slime.tscn"),
	"Red slime": preload("res://scenes/Enemy/red_slime.tscn"),
	"Yellow slime": preload("res://scenes/Enemy/yellow_slime.tscn"),
	"Black slime": preload("res://scenes/Enemy/black_slime.tscn"),
	"Tarnished purple": preload("res://scenes/Enemy/tarnished_purple.tscn"),
	"Tarnished turquoize": preload("res://scenes/Enemy/tarnished_turquoize.tscn"),
	"Robobot": preload("res://scenes/Enemy/robobot.tscn"),
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
		get_child(3).queue_free()
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

var time_elapsed = 0.0
func _process(delta: float):
	time_elapsed += delta
	var snapped_time = snapped(time_elapsed, 0.1)
	
	if snapped_time == 1:
		if timed_spawns == 0:
			for i in range(3):
				spawn(enemies.get("Blitzer"))
			boss_spawn(enemies.get("Tarnished purple"))
			timed_spawns = 1
	elif snapped_time == 75:
		if timed_spawns == 1:
			boss_spawn(enemies.get("Black slime"))
			timed_spawns = 2
	elif snapped_time == 125:
		if timed_spawns == 2:
			for i in range(2):
				boss_spawn(enemies.get("Tarnished turquoize"))
			boss_spawn(enemies.get("Black slime"))
			timed_spawns = 3
	elif snapped_time == 240:
		if timed_spawns == 3:
			for i in range(30):
				boss_spawn(enemies.get("Triangle mage"))
			boss_spawn(enemies.get("Black slime"))
			boss_spawn(enemies.get("Blitzer"))
			timed_spawns = 4

func _wave_system_spacing():
	var enemy = []
	var wave = 0
	var selected = 0
	if time_elapsed < 12: #wave 1
		if wave == 0:
			enemy.clear()
			wave = 1
		if enemy.is_empty():
			enemy.append(["Green slime", 0.1])
		selected = 0
	elif time_elapsed < 32: #wave 2
		if wave == 1:
			enemy.clear()
			wave = 2
		if enemy.is_empty():
			enemy.append(["Blue slime", 0.15])
			enemy.append(["Robobot", 0.25])
		selected = randi_range(0, 1)
	elif time_elapsed < 38: #wave 3
		if wave == 2:
			enemy.clear()
			wave = 3
		if enemy.is_empty():
			enemy.append(["Green slime", 0.05])
		selected = 0
	elif time_elapsed < 60:
		if wave == 3:
			enemy.clear()
			wave = 4
		if enemy.is_empty():
			enemy.append(["Red slime", 0.25])
			enemy.append(["Triangle mage", 0.5])
			enemy.append(["Robobot", 0.25])
		selected = randi_range(0, 2)	
	elif time_elapsed < 80:
		if wave == 4:
			enemy.clear()
			wave = 5
		if enemy.is_empty():
			enemy.append(["Blue slime", 0.15])
			enemy.append(["Red slime", 0.25])
			enemy.append(["Tarnished purple", 0.4])
		selected = randi_range(0, 2)	
	elif time_elapsed < 100:
		if wave == 3:
			enemy.clear()
			wave = 4
		if enemy.is_empty():
			enemy.append(["Triangle mage", 0.35])
			enemy.append(["Tarnished purple", 0.4])
			enemy.append(["Robobot", 0.2])
			enemy.append(["Blue slime", 0.1])
		selected = randi_range(0, 3)
	elif time_elapsed < 125:
		if wave == 4:
			enemy.clear()
			wave = 5
		if enemy.is_empty():
			for i in range(4):
				enemy.append(["Tarnished purple", 0.35])
				enemy.append(["Red slime", 0.2])
				enemy.append(["Blue slime", 0.1])
			enemy.append(["Blitzer", 1.2])
		selected = randi_range(0, 12)
	elif time_elapsed < 130:
		if wave == 5:
			enemy.clear()
			wave = 6
		if enemy.is_empty():
			enemy.append(["Blue slime", 0.05])
		selected = 0
	elif time_elapsed < 170:
		if wave == 6:
			enemy.clear()
			wave = 7
		if enemy.is_empty():
			enemy.append(["Red slime", 0.15])
			enemy.append(["Yellow slime", 0.3])
			enemy.append(["Tarnished purple", 0.3])
			enemy.append(["Triangle mage", 0.3])
		selected = randi_range(0, 3)
	elif time_elapsed < 205:
		if wave == 7:
			enemy.clear()
			wave = 8
		if enemy.is_empty():
			enemy.append(["Triangle mage", 0.3])
			enemy.append(["Yellow slime", 0.3])
			enemy.append(["Green slime", 0.05])
			enemy.append(["Tarnished turquoize", 0.75])
		selected = randi_range(0, 3)
	else:
		if enemy.is_empty():
			enemy.append(["Yellow slime", 0.2])
		selected = 0
	spawn(enemies.get(enemy[selected][0]))
	$SpawnInterval.start(enemy[selected][1])	
	await $SpawnInterval.is_stopped()

func _ready():
	$SpawnInterval.start()
