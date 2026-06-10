extends Node2D


var difficulty = 0


func spawn_mob():
	var new_mob = ""
	if difficulty < 3:
		new_mob = preload("res://scenes/Enemy/green_slime.tscn").instantiate()
	elif difficulty < 8:
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
