extends Node

var win_time = 401

var timed_spawns = 0
@onready var path = %PathFollow2D

var enemies = {
	"Red slime": preload("res://scenes/Enemy/red_slime.tscn"),
	"Yellow slime": preload("res://scenes/Enemy/yellow_slime.tscn"),
	"Black slime": preload("res://scenes/Enemy/black_slime.tscn"),
	"Tarnished purple": preload("res://scenes/Enemy/tarnished_purple.tscn"),
	"Tarnished turquoize": preload("res://scenes/Enemy/tarnished_turquoize.tscn"),
	"Pillar": preload("res://scenes/Enemy/pillar.tscn"),
	"Blitzer": preload("res://scenes/Enemy/blitzer.tscn"),
	"Triangle mage": preload("res://scenes/Enemy/triangle_mage.tscn"),
	"Projector": preload("res://scenes/Enemy/projector_mk_1.tscn"),
	"Mecha": preload("res://scenes/Enemy/tin_mecha.tscn")
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
	new_mob.damage *= 2.5
	new_mob.scale *= 1.5
	if "shield" in new_mob:
		new_mob.shield *= 5
		new_mob.shield_base *= 5
	if "boss" in new_mob:
		new_mob.boss = true
	
	path.progress_ratio = randf()
	new_mob.global_position = path.global_position
	$Boss.add_child(new_mob)

var time_elapsed = 0.0
func _process(delta: float):
	time_elapsed += delta
	var snapped_time = snapped(time_elapsed, 0.1)
	
	if snapped_time == 100:
		if timed_spawns == 0:
			boss_spawn(enemies.get("Pillar"))
			timed_spawns = 1
	elif snapped_time == 200:
		if timed_spawns == 1:
			boss_spawn(enemies.get("Tarnished turquoize"))
			boss_spawn(enemies.get("Black slime"))
			timed_spawns = 2
	elif snapped_time == 300:
		if timed_spawns == 2:
			for i in range(2):
				boss_spawn(enemies.get("Projector"))
				boss_spawn(enemies.get("Blitzer"))
			boss_spawn(enemies.get("Tarnished turquoize"))
			timed_spawns = 3
	elif snapped_time == 400:
		if timed_spawns == 3:
			for i in range(5):
				boss_spawn(enemies.get("Projector"))
				boss_spawn(enemies.get("Triangle mage"))
				boss_spawn(enemies.get("Blitzer"))
				boss_spawn(enemies.get("Tarnished turquoize"))
			boss_spawn(enemies.get("Mecha"))
			timed_spawns = 4

func _wave_system_spacing():
	var enemy = []
	var wave = 0
	var selected = 0
	if time_elapsed < 40: #wave 1
		if wave == 0:
			enemy.clear()
			wave = 1
		if enemy.is_empty():
			enemy.append(["Red slime", 0.8])
		selected = 0
	elif time_elapsed < 60: #wave 2
		if wave == 1:
			enemy.clear()
			wave = 2
		if enemy.is_empty():
			for i in range(4):
				enemy.append(["Red slime", 0.6])
			enemy.append(["Pillar", 2.4])
		selected = randi_range(0, 4)
	elif time_elapsed < 100: #wave 3
		if wave == 2:
			enemy.clear()
			wave = 3
		if enemy.is_empty():
			enemy.append(["Tarnished purple", 0.75])
		selected = 0
	elif time_elapsed < 140:
		if wave == 3:
			enemy.clear()
			wave = 4
		if enemy.is_empty():
			enemy.append(["Tarnished purple", 0.75])
			enemy.append(["Red slime", 0.75])
			enemy.append(["Yellow slime", 1.2])
		selected = randi_range(0, 2)	
	elif time_elapsed < 150:
		if wave == 4:
			enemy.clear()
			wave = 5
		if enemy.is_empty():
			enemy.append(["Pillar", 1.8])
		selected = 0
	elif time_elapsed < 180:
		if wave == 3:
			enemy.clear()
			wave = 4
		if enemy.is_empty():
			enemy.append(["Triangle mage", 0.9])
			enemy.append(["Yellow slime", 1.0])
		selected = randi_range(0, 1)
	elif time_elapsed < 200:
		if wave == 4:
			enemy.clear()
			wave = 5
		if enemy.is_empty():
			enemy.append(["Tarnished purple", 0.4])
		selected = 0
	elif time_elapsed < 235:
		if wave == 5:
			enemy.clear()
			wave = 6
		if enemy.is_empty():
			enemy.append(["Tarnished purple", 0.5])
			enemy.append(["Tarnished turquoize", 1.25])
		selected = randi_range(0, 1)
	elif time_elapsed < 280:
		if wave == 6:
			enemy.clear()
			wave = 7
		if enemy.is_empty():
			for i in range(5):
				enemy.append(["Red slime", 0.3])
				enemy.append(["Tarnished purple", 0.4])
				enemy.append(["Yellow slime", 0.7])
				enemy.append(["Tarnished turquoize", 1.0])
			enemy.append(["Blitzer", 0.5])
			enemy.append(["Pillar", 0.5])
			enemy.append(["Triangle mage", 0.5])
		selected = randi_range(0, 22)
	elif time_elapsed < 300:
		if wave == 7:
			enemy.clear()
			wave = 8
		if enemy.is_empty():
			enemy.append(["Black slime", 1.25])
		selected = 0
	elif time_elapsed < 350:
		if wave == 8:
			enemy.clear()
			wave = 9
		if enemy.is_empty():
			enemy.append(["Yellow slime", 0.5])
		selected = 0
	elif time_elapsed < 400:
		if wave == 9:
			enemy.clear()
			wave = 10
		if enemy.is_empty():
			for i in range(6):
				enemy.append(["Yellow slime", 0.6])
				enemy.append(["Tarnished turquoize", 0.75])
				enemy.append(["Black slime", 1.1])
			enemy.append(["Blitzer", 0.8])
			enemy.append(["Pillar", 0.8])
			enemy.append(["Triangle mage", 0.8])
			enemy.append(["Projector", 0.8])
		selected = randi_range(0, 21)
	else:
		if enemy.is_empty():
			enemy.append(["Blitzer", 1.0])
			enemy.append(["Pillar", 1.0])
			enemy.append(["Triangle mage", 1.0])
			enemy.append(["Projector", 1.0])
			enemy.append(["Black slime", 1.0])
			enemy.append(["Black slime", 1.0])
		selected = randi_range(0, 4)
	spawn(enemies.get(enemy[selected][0]))
	$SpawnInterval.start(enemy[selected][1])	
	await $SpawnInterval.is_stopped()

func _ready():
	$SpawnInterval.start()
