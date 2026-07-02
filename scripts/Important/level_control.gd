extends Node2D
var level_menu = false

func _on_player_level_up():
	%LevelUp.visible = true
	get_tree().paused = true
	get_parent().level_menu = true

func _on_level_up_level_up_selected():
	var info = %LevelUp.upgrade_option
	if info == 1:
		%Player.damage_multi += 0.2
	elif info == 2:
		%Player.regen_multi += 0.25
		%Player.health += 60.0
	elif info == 3:
		%Player.max_health_multi += 0.1
	elif info == 4:
		print("speed")
	elif info == 5:
		print("Defense")
	elif info <= 11:
		%Player.get_node("Gun").weapon_levels[info - 6] += 1
	else:
		print("Hi")
	%Player.stat_upgraded()
	%LevelUp.visible = false
	get_tree().paused = false
	get_parent().level_menu = false
