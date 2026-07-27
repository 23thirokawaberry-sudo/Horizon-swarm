extends Node2D
var level_menu = false

func _on_player_level_up():
	%LevelUp.visible = true
	get_tree().paused = true
	get_parent().level_menu = true

func _on_level_up_level_up_selected():
	var info = %LevelUp.upgrade_option
	if info < 8:
		%Player.temp_levels[info] += 1
	elif info <= 15:
		%Player.get_node("Gun").weapon_levels[info - 8][1] += 1
	else:
		print("Hi")
	%LevelUp.upgrades[info][1] += 1
	%Player.stat_upgraded()
	%LevelUp.visible = false
	get_tree().paused = false
	get_parent().level_menu = false
