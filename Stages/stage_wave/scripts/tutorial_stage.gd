extends Node

var win_time = 116

var time_elapsed = 0.0
var overflowed_enemies = 0
var timed_spawns = 0
@onready var path = get_parent().find_child("Player").find_child("Path2D").find_child("PathFollow2D")

var dialog_text = ["Welcome to the game \n Before we start, I will explain the controls.", 
					"You can move around by holding down the WASD keys or the arrow keys. W A S D keys will move you Up, Left, Down, Right respectively.", 
					"You can also aim your weapon using the mouse cursor. Your gun will fire automatically towards the cursor, so all you have to do is aim. Try aiming towards those slimes. If they get too close, move out of the way.", 
					"The black walls surrounding the area as well as those boxes are solid, and you can't walk through them, nor can your weapons shoot through them.",
					"If you did kill the slimes, then they would have dropped an XP orb. Go near it and it will be collected for you.",
					"Up on the top left, there is your health bar and Xp bar. \nIf your health bar reaches 0, you will lose. \nWhen your xp bar fills up, you will level up. ", 
					"If you level up, you will be given 3 cards, which gives you weapons or boosts your stats. You can also pause using the P or escape key to view the current weapons you have.", 
					"Enemies will begin to spawn more frequently now.",
					"Although the number of enemies seem a little more overwhelming now, it is still very slow compared to later stages.", 
					"At certain times, a boss enemy will spawn. The boss will spawn at 115 seconds on this stage, so it will be in 35 seconds.",
					"All bosses have to be defeated in order for you to clear the stage. Stages can also have more than 1 boss spawn times, and more than 1 bosses can spawn at once. ",
					"The boss is spawning in 10 seconds. Be careful, as it will move towards you faster. Remember to move away if you are getting cornered.", 
					"The boss is here. It is larger than how it would normally be, and it also has more health and damage. There is a health bar for the boss, so you can track how close they are to dying."]

var enemies = {
	"Green slime": preload("res://scenes/Enemy/green_slime.tscn"),
	"Blue slime": preload("res://scenes/Enemy/blue_slime.tscn")
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
	var enemy = []
	var wave = 0
	var selected = 0
	if time_elapsed < 50: #wave 1
		if wave == 0:
			enemy.clear()
			wave = 1
		if enemy.is_empty():
			enemy.append(["Green slime", 9])
		selected = 0
	elif time_elapsed < 80: #wave 2
		if wave == 1:
			enemy.clear()
			wave = 2
		if enemy.is_empty():
			enemy.append(["Green slime", 1])
		selected = 0
	elif time_elapsed < 115: #wave 3
		if wave == 2:
			enemy.clear()
			wave = 3
		if enemy.is_empty():
			enemy.append(["Green slime", 0.8])
		selected = 0
	else:
		if enemy.is_empty():
			enemy.append(["Green slime", 0.5])
		selected = 0
	spawn(enemies.get(enemy[selected][0]))
	$SpawnInterval.start(enemy[selected][1])	
	await $SpawnInterval.is_stopped()

func _ready():
	$SpawnInterval.start()
