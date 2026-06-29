extends Node

var time_elapsed = 0.0
func _process(delta: float):
	time_elapsed += delta

var enemies = {
	"Green slime": preload("res://scenes/Enemy/green_slime.tscn"),
	"Blue slime": preload("res://scenes/Enemy/blue_slime.tscn"),
	"Black slime": preload("res://scenes/Enemy/black_slime.tscn")
	}
	
func spawn(mob):
	var new_mob = mob.instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)

func _wave_system_spacing():
	var enemy = []
	var wave = 0
	var selected = 0
	if time_elapsed < 30: #wave 1
		if wave == 0:
			enemy.clear()
			wave = 1
		if enemy.is_empty():
			enemy.append(["Green slime", 0.2])
		selected = 0
	elif time_elapsed < 60: #wave 2
		if wave == 1:
			enemy.clear()
			wave = 2
		if enemy.is_empty():
			enemy.append(["Blue slime", 0.5])
		selected = 0
	elif time_elapsed < 75: #wave 3
		if wave == 2:
			enemy.clear()
			wave = 3
		if enemy.is_empty():
			enemy.append(["Green slime", 0.2])
			enemy.append(["Blue slime", 0.5])
		selected = randi_range(0, 1)	
	else:
		print("your'e winer")
	spawn(enemies.get(enemy[selected][0]))
	$SpawnInterval.start(enemy[selected][1])	
	await $SpawnInterval.is_stopped()
		
func _ready():
	$SpawnInterval.start()
