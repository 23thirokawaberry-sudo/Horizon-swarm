extends Node

var win_time = 110
const ENEMY_APPEARENCES = ["Green slime", "Blue slime", "Tin robobot", "Triangle mage", "Blitzer", "Tarnished purple", "Tarnished turquoize", "Tin projector"]

var timed_spawns = 0
@onready var paths = [%PathFollow2D, %PathFollow2D2]
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
		var path = paths[0]
		path.progress_ratio = randf()
		spawn_mob.global_position = path.global_position
		add_child(spawn_mob)
		$SpawnInterval.start()
	else:
		get_child(4).queue_free()

func boss_spawn(mob):
	const BOSSBAR = preload("res://scenes/Important/boss_bar.tscn")
	var new_mob = mob.instantiate()
	new_mob.health *= 30
	new_mob.max_health *= 30
	new_mob.damage *= 2.25
	new_mob.scale *= 2.25
	if "shield" in new_mob:
		new_mob.shield *= 6
		new_mob.shield_base *= 6
	if "boss" in new_mob:
		new_mob.boss = true
	var path = paths[1]
	path.progress_ratio = randf()
	new_mob.global_position = path.global_position
	$Boss.add_child(new_mob)
	var new_bar = BOSSBAR.instantiate()
	new_mob.add_child(new_bar)


var time_elapsed = 0.0
func _process(delta: float):
	time_elapsed += delta
	var snapped_time = snapped(time_elapsed, 0.1)
	
	if snapped_time == 1:
		if timed_spawns == 0:
			boss_spawn(enemies.get("Tin projector"))
			timed_spawns = 1

func _wave_system_spacing():
	if time_elapsed < 10: #wave 1
		spawn([["Green slime", 1, 0.4]])
	elif time_elapsed < 55: #wave 2
		spawn([["Green slime", 2, 0.35], ["Blue slime", 3, 0.55], ["Tin robobot", 4, 0.6]])
	elif time_elapsed < 90:
		spawn([["Green slime", 3, 0.3], ["Blue slime", 6, 0.5], ["Tarnished purple", 7, 0.9]])
	elif time_elapsed < 135:
		spawn([["Blue slime", 3, 0.5], ["Tin robobot", 6, 0.5], ["Tarnished purple", 7, 0.85]])
	elif time_elapsed < 180:
		spawn([["Blue slime", 4, 0.45], ["Tarnished purple", 5, 0.85], ["Triangle mage", 6, 1.0]])
	elif time_elapsed < 220:
		spawn([["Blue slime", 3, 0.4], ["Tarnished purple", 4, 0.8], ["Triangle mage", 5, 0.85]])
	elif time_elapsed < 260:
		spawn([["Blue slime", 8, 0.4], ["Tarnished purple", 12, 0.8], ["Triangle mage", 16, 0.75], ["Blitzer", 17, 1.5]])
	elif time_elapsed < 300:
		spawn([["Blue slime", 5, 0.35], ["Tarnished purple", 10, 0.75], ["Triangle mage", 14, 0.7], ["Blitzer", 15, 1.5]])
	elif time_elapsed < 350:
		spawn([["Blue slime", 2, 0.25], ["Tarnished purple", 8, 0.7], ["Triangle mage", 12, 0.65], ["Blitzer", 13, 1.2]])
	else:
		spawn([["Tarnished purple", 5, 0.7], ["Tarnished turquoize", 6, 3.5]])

func _ready():
	$SpawnInterval.start()
