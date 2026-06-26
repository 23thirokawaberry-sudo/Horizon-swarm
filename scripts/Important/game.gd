extends Node2D


var difficulty = 0
var level_menu = false

func spawn_mob():
	var new_mob = ""
	if difficulty < 2:
		new_mob = preload("res://scenes/Enemy/green_slime.tscn").instantiate()
	elif difficulty < 5:
		new_mob = preload("res://scenes/Enemy/blue_slime.tscn").instantiate()
	else:
		new_mob = preload("res://scenes/Enemy/black_slime.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)


func _on_spawn_timeout():
	
	spawn_mob()


func _on_difficulty_rise_timeout():
	difficulty += 1


func _on_player_death():
	%GameOver.visible = true
	get_tree().paused = true
	
func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Important/title.tscn")

func _on_player_level_up():
	%LevelUp.visible = true
	get_tree().paused = true
	level_menu = true

func _on_level_up_level_up_selected():
	var info = %LevelUp.upgrade_option
	if info == 1:
		%Player.damage += 1.0
	elif info == 2:
		%Player.regen += 1.0
		%Player.health += 8.0
	elif info == 3:
		%Player.max_health += 8.0
	elif info < 6:
		%Player.get_node("Gun").weapon_levels[info - 4] += 1
	else:
		print("Hi")
	%Player.stat_upgraded()
	
	
	%LevelUp.visible = false
	get_tree().paused = false
	level_menu = false
