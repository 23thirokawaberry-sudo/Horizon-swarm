extends Node

var win_time = 201
const WEAPON_UNLOCK = ["Sniper", "Gatling"]
const ENEMY_APPEARENCES = ["Green slime", "Blue slime", "Red slime", "Yellow slime", "Black slime"]


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
	if time_elapsed < 30: #wave 1
		spawn([["Green slime", 1, 0.8]])
	elif time_elapsed < 45: #wave 2
		spawn([["Blue slime", 1, 1.2]])
	elif time_elapsed < 75: #wave 3
		spawn([["Green slime", 2, 0.7], ["Blue slime", 3, 1.2]])	
	elif time_elapsed < 95:
		spawn([["Green slime", 2, 0.6], ["Blue slime", 3, 1.1]])	
	elif time_elapsed < 120:
		spawn([["Blue slime", 1, 1.0]])
	elif time_elapsed < 165:
		spawn([["Green slime", 3, 0.5], ["Red slime", 4, 1.35]])	
	elif time_elapsed < 200:
		spawn([["Green slime", 2, 0.45], ["Blue slime", 4, 0.8], ["Red slime", 5, 1.2]])	
	else:
		spawn([["Red slime", 1, 1.0]]) #end enemy(ies). They have unfair stats designed to end the game. Black slime is currently temporary.

func _ready():
	$SpawnInterval.start()
