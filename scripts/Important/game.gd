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
	get_tree().paused = false


func _on_player_level_up():
	%LevelUp.visible = true
	get_tree().paused = true
	level_menu = true
	
func upgrade_selected():
	%LevelUp.visible = false
	get_tree().paused = false
	level_menu = false

func _on_choice_1_pressed():
	%Player.max_health += 10.0
	%Player.health += 8.0
	%Player.stat_upgraded()
	print(%Player.max_health)
	upgrade_selected()

func _on_choice_2_pressed():
	%Player.damage += 1.0
	upgrade_selected()

func _on_choice_3_pressed():
	%Player.regen += 1.0
	%Player.health += 20.0
	%Player.stat_upgraded()
	upgrade_selected()
