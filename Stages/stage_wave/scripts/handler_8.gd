extends Node

var win_time = 401
const ENEMY_APPEARENCES = ["Blue slime", "Red slime", "Yellow slime", "Tin robobot", "Copper robobot", "Steel robobot", "Tarnished purple", "Tin projector", "Triangle mage", "Red stickman", "Green stickman", "Sandstone pillar", "Tin turret", "Tin oMecha"]

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
	if "shield" in new_mob:
		new_mob.shield *= 5
		new_mob.shield_base *= 5
	if "boss" in new_mob:
		new_mob.boss = true
	path.progress_ratio = randf()
	new_mob.global_position = path.global_position
	$Boss.add_child(new_mob)
	var new_bar = BOSSBAR.instantiate()
	new_mob.add_child(new_bar)


var time_elapsed = 0.0
func _process(delta: float):
	time_elapsed += delta
	var snapped_time = snapped(time_elapsed, 0.1)
	
	if snapped_time == 100:
		if timed_spawns == 0:
			boss_spawn(enemies.get("Tin oMecha"))
			timed_spawns = 1
	elif snapped_time == 200:
		if timed_spawns == 1:
			boss_spawn(enemies.get("Sandstone pillar"))

func _wave_system_spacing():
	if time_elapsed < 20: #wave 1
		spawn([["Blue slime", 1, 0.5]])
	elif time_elapsed < 32: #wave 2
		spawn([["Red slime", 1, 0.65], ["Blue slime", 3, 0.45]])
	elif time_elapsed < 60:
		spawn([["Red slime", 2, 0.6], ["Blue slime", 5, 0.45], ["Tarnished purple", 6, 0.8], ["Tin robobot", 8, 0.6]])
	elif time_elapsed < 70:
		spawn([["Red slime", 3, 0.5], ["Tin robobot", 6, 0.5], ["Tarnished purple", 7, 0.85]])
	elif time_elapsed < 100:
		spawn([["Red stickman", 1, 1.2], ["Green stickman", 2, 1.2]])
	elif time_elapsed < 150:
		spawn([["Blue slime", 2, 0.45], ["Red stickman", 3, 1.1], ["Green stickman", 4, 1.1]])
	elif time_elapsed < 180:
		spawn([["Blue slime", 9, 0.4], ["Red stickman", 12, 1.1], ["Green stickman", 15, 1.1], ["Triangle mage", 16, 0.5]])
	elif time_elapsed < 190:
		spawn([["Red slime", 8, 0.5], ["Red stickman", 12, 1.1], ["Green stickman", 16, 1.1], ["Triangle mage", 17, 0.85], ["Tin projector", 18, 0.59]])
	elif time_elapsed < 225:
		spawn([["Red slime", 7, 0.5], ["Tarnished purple", 13, 0.7], ["Triangle mage", 15, 0.8], ["Tin projector", 16, 1.5]])
	elif time_elapsed < 235:
		spawn([["Sandstone pillar", 1, 1.0]])
	elif time_elapsed < 260:
		spawn([["Red slime", 2, 0.45], ["Red stickman", 3, 1.0], ["Green stickman", 4, 1.0]])
	elif time_elapsed < 300:
		spawn([["Yellow slime", 4, 0.8], ["Copper robobot", 8, 0.8], ["Red stickman", 10, 1.0], ["Green stickman", 12, 1.0], ["Sandstone pillar", 13, 1.0]])
	elif time_elapsed < 333:
		spawn([["Tin robobot", 3, 0.5], ["Copper robobot", 5, 0.8], ["Steel robobot", 6, 1.0]])
	elif time_elapsed < 350:
		spawn([["Sandstone pillar", 1, 0.9]])
	elif time_elapsed < 400:
		spawn([["Copper robobot", 3, 0.8], ["Steel robobot", 6, 1.0], ["Yellow slime", 9, 0.7], ["Tarnished purple", 12, 0.7], ["Triangle mage", 14, 0.5], ["Sandstone pillar", 15, 0.5], ["Tin projector", 16, 0.5], ["Red stickman", 20, 0.8]])
	else:
		spawn([["Tarnished purple", 10, 0.65], ["Steel robobot", 14, 0.9], ["Tin projector", 15, 1.0], ["Green stickman", 18, 0.8]])

func _ready():
	$SpawnInterval.start()
