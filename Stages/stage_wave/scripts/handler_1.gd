extends Node

var win_time = 161
const ENEMY_APPEARENCES = ["Green slime", "Blue slime", "Red slime", "Tarnished purple"]

var timed_spawns = 0
@onready var paths = [%PathFollow2D, %PathFollow2D2, %PathFollow2D3, %PathFollow2D4]

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
		var path = paths.pick_random()
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
	var path = paths.pick_random()
	path.progress_ratio = randf()
	new_mob.global_position = path.global_position
	$Boss.add_child(new_mob)
	var new_bar = BOSSBAR.instantiate()
	new_mob.add_child(new_bar)

var time_elapsed = 0.0
func _process(delta: float):
	time_elapsed += delta
	var snapped_time = snapped(time_elapsed, 0.1)
	
	if snapped_time == 160:
		if timed_spawns == 0:
			boss_spawn(enemies.get("Tarnished purple"))
			timed_spawns = 1

func _wave_system_spacing():
	if time_elapsed < 25: #wave 1
		spawn([["Green slime", 1, 1.25]])
	elif time_elapsed < 36: #wave 2
		spawn([["Green slime", 3, 1.15], ["Blue slime", 4, 1.5]])
	elif time_elapsed < 45: #wave 3
		spawn([["Blue slime", 1, 1.4]])
	elif time_elapsed < 65:
		spawn([["Green slime", 3, 1.05], ["Blue slime", 4, 1.25]])
	elif time_elapsed < 80:
		spawn([["Green slime", 3, 1.0], ["Red slime", 4, 3.0]])
	elif time_elapsed < 100:
		spawn([["Blue slime", 1, 1.25]])
	elif time_elapsed < 110:
		spawn([["Green slime", 5, 0.95], ["Blue slime", 8, 1.25], ["Red slime", 9, 1.55]])
	elif time_elapsed < 135:
		spawn([["Red slime", 1, 2.0]])
	elif time_elapsed < 145:
		spawn([["Blue slime", 2, 1.2], ["Red slime", 3, 1.8]])
	elif time_elapsed < 160:
		spawn([["Green slime", 4, 0.8], ["Blue slime", 6, 1.2], ["Red slime", 7, 1.8]])
	else:
		spawn([["Green slime", 2, 0.65], ["Blue slime", 3, 1.1]])

func _ready():
	$SpawnInterval.start()
