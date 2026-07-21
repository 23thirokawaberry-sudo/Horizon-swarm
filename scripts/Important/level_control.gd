extends Node2D
var level_menu = false

func _on_player_level_up():
	%LevelUp.visible = true
	get_tree().paused = true
	get_parent().level_menu = true

func _on_level_up_level_up_selected():
	var info = %LevelUp.upgrade_option
	if info == 0:
		%Player.damage_multi += 0.2
	elif info == 1:
		%Player.max_health += 10
	elif info == 2:
		%Player.regen += 0.5
		%Player.health += 60.0
	elif info <= 7:
		print("temp")
	elif info <= 15:
		%Player.get_node("Gun").weapon_levels[info - 8][1] += 1
		print(info)
	else:
		print("Hi")
	%Player.stat_upgraded()
	%LevelUp.visible = false
	get_tree().paused = false
	get_parent().level_menu = false
