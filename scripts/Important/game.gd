extends Node2D
var level_menu = false
var paused = false

func time():
	return $Enemies.time_elapsed

func _on_pause():
	if paused == false:
		%Pause.visible = true
		paused = true
		get_tree().paused = true
	else:	
		%Pause.visible = false
		paused = false
		get_tree().paused = false

func _on_player_death():
	%GameOver.visible = true
	get_tree().paused = true
	
func _on_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Important/title.tscn")

func _on_player_level_up():
	%LevelUp.visible = true
	get_tree().paused = true
	level_menu = true

func _on_level_up_level_up_selected():
	var info = %LevelUp.upgrade_option
	if info == 1:
		%Player.damage_multi += 0.2
	elif info == 2:
		%Player.regen_multi += 0.25
		%Player.health += 60.0
	elif info == 3:
		%Player.max_health_multi += 0.1
	elif info < 8:
		%Player.get_node("Gun").weapon_levels[info - 4] += 1
	else:
		print("Hi")
	%Player.stat_upgraded()
	level_menu = false
	
	
	%LevelUp.visible = false
	get_tree().paused = false
	level_menu = false
