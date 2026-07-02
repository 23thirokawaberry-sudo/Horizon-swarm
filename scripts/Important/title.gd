extends Control
var current_page = null

func _on_play_pressed():
	$Label.visible = false
	$Menu.visible = true
	%Start.visible = false
	current_page = $Menu

func _on_stages_pressed():
	$Menu.visible = false
	$Stages.visible = true
	current_page = $Stages

func _on_back_pressed():
	current_page.visible = false
	if current_page == $Stages:
		%Start.visible = false
	DataTransfer.selected_stage = -1
	$Menu.visible = true
	current_page = $Menu

func _on_stage_1_pressed():
	DataTransfer.selected_stage = 0
	%Start.visible = true

func _on_stage_2_pressed() -> void:
	DataTransfer.selected_stage = 1
	%Start.visible = true

func _on_start_pressed():
	if DataTransfer.selected_stage != -1:
		get_tree().change_scene_to_file("res://Stages/stage_map/scenes/game.tscn")
