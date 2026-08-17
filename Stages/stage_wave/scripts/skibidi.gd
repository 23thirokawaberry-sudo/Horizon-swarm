extends Node

var win_time = 361

var time_elapsed = 0.0
var timed_spawns = 0
@onready var path = %PathFollow2D
const ENEMY_APPEARENCES = ["Green slime", "Red slime", "Black slime", "Tarnished purple", "Tarnished turquoize", "Triangle mage"]
const WEAPON_UNLOCK = ["Mortar", "Dagger", "Katana", "Mine"]

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
	print("not done but there are bosses. this stage might get scrapped.")

func _ready():
	$SpawnInterval.start()
