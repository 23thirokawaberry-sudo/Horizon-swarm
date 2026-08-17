extends Node

var win_time = 116
const ENEMY_APPEARENCES = ["Blue slime", "Tin robobot", "Triangle mage"]

var time_elapsed = 0.0
var timed_spawns = 0
@onready var path = get_parent().find_child("Player").find_child("Path2D").find_child("PathFollow2D")

var dialog_text = ["This tutorial is about some new mechanics. There is no boss here.", 
					"You may notice the blue tiles around you. These are player blocking tiles, and they only block the player.", 
					"Your projectiles will ignore these tiles, but you can't walk across them. There are other tiles like this, such as lava tiles.", 
					"If you haven't checked the enemy database, you should as it includes some information about the enemies and their mechanics.",
					"This stage will explain how the enemies 'Robobot' and 'Mage' will work. You should have already encountered robobot last stage.",
					"Robobot is an enemy with fairly low health, however it has a special 'Defense' stat, which reduces incoming damage by a flat amount, similar to your defense stat.", 
					"Low damaging weapons such as shotgun and gatling are bad at damaging robobot, dealing 1 damage unless you increase your damage by a lot.", 
					"Mage is a ranged enemy that fires projectiles. The projectiles it fires deal the same damage as it's contact damage.",
					"Because they are really slow, they end up staying in far unreachable locations. Use weapons such as sniper and beam to kill them.", 
					"Mages as bosses will fire larger projectiles and their projectiles also deal more damage, so be careful around them as well.",
					"Other enemies that you still haven't encountered yet can also fire projectiles in their attacks through different means, so try prioritizing them before you get overwhelmed.",
					"Of course, if the enemy is in an unreachable location, just let them come near to deal with them and get their xp.",
					"I'm lazy and I haven't finished this stage's dialog. stage will end at 160 seconds.", 
					"Stages with hoards of enemies, whether they are dangerous or not, may feel easier sometimes as they give you lots of xp to level up.",
					"Try to not continuously kill enemies in unreachable locations, otherwise you may not get enough levels for future waves.", 
					"Remember to go to the shop if the enemies are too difficult. You can get more starting weapons and better stats, which will make everything easier.", 
					"This stage also doesn't have a boss so it will end very soon. The next stage will have player blocking tiles and ranged attackers so be careful."]

@onready var enemies = get_parent().ENEMIES

func spawn(mobs):
	if get_child_count() <= 155:
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
		get_child(5).queue_free()

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

func _process(delta: float):
	time_elapsed += delta
	var snapped_time = snapped(time_elapsed, 0.1)
	
	if snapped_time < 5:
		if timed_spawns == 0:
			timed_spawns = 1
			$Dialog.visible = true
			%DialogTimer.start(5)
			%Label.text = dialog_text[0]
	elif snapped_time == 5:
		if timed_spawns == 1:
			timed_spawns = 2
			$Dialog.visible = true
			%DialogTimer.start(7)
			%Label.text = dialog_text[1]
	elif snapped_time == 12:
		if timed_spawns == 2:
			timed_spawns = 3
			$Dialog.visible = true
			%DialogTimer.start(8)
			%Label.text = dialog_text[2]
	elif snapped_time == 20:
		if timed_spawns == 3:
			timed_spawns = 4
			$Dialog.visible = true
			%DialogTimer.start(7)
			%Label.text = dialog_text[3]
	elif snapped_time == 27:
		if timed_spawns == 4:
			timed_spawns = 5
			$Dialog.visible = true
			%DialogTimer.start(8)
			%Label.text = dialog_text[4]
	elif snapped_time == 35:
		if timed_spawns == 5:
			timed_spawns = 6
			$Dialog.visible = true
			%DialogTimer.start(7)
			%Label.text = dialog_text[5]
	elif snapped_time == 42:
		if timed_spawns == 6:
			timed_spawns = 7
			$Dialog.visible = true
			%DialogTimer.start(8)
			%Label.text = dialog_text[6]
	elif snapped_time == 50:
		if timed_spawns == 7:
			timed_spawns = 8
			$Dialog.visible = true
			%DialogTimer.start(6)
			%Label.text = dialog_text[7]
	elif snapped_time == 58:
		if timed_spawns == 8:
			timed_spawns = 9
			$Dialog.visible = true
			%DialogTimer.start(8)
			%Label.text = dialog_text[8]
	elif snapped_time == 80:
		if timed_spawns == 9:
			timed_spawns = 10
			$Dialog.visible = true
			%DialogTimer.start(8)
			%Label.text = dialog_text[9]
	elif snapped_time == 88:
		if timed_spawns == 10:
			timed_spawns = 11
			$Dialog.visible = true
			%DialogTimer.start(6)
			%Label.text = dialog_text[10]
	elif snapped_time == 105:
		if timed_spawns == 11:
			timed_spawns = 12
			$Dialog.visible = true
			%DialogTimer.start(10)
			%Label.text = dialog_text[11]
	elif snapped_time == 115:
		if timed_spawns == 12:
			timed_spawns = 13
			$Dialog.visible = true
			%DialogTimer.start(6)
			%Label.text = dialog_text[12]
			boss_spawn(enemies.get("Blue slime"))

func _on_dialog_timer_timeout():
	$Dialog.visible = false

func _wave_system_spacing():
	if time_elapsed < 40: #wave 1
		spawn([["Blue slime", 1, 1.5]])
	elif time_elapsed < 80: #wave 2
		spawn([["Tin robobot", 1, 2.8]])
	elif time_elapsed < 120: #wave 3
		spawn([["Triangle mage", 1, 4.5]])
	elif time_elapsed < 161:
		spawn([["Green slime", 1, 1.2], ["Tin robobot", 1, 2.2], ["Triangle mage", 1, 3.8]])

func _ready():
	$SpawnInterval.start()
