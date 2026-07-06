extends Node2D
var level_menu = false
var paused = false
var timer = 0

var base_stats = DataTransfer.base_player_stats
var stage = DataTransfer.selected_stage

const STAGE_DATA = [
	preload("res://Stages/stage_wave/scenes/enemy_spawn_handler.tscn"),
	preload("res://Stages/stage_wave/scenes/handler_2.tscn")]

func _ready():
	var enemies = STAGE_DATA[stage].instantiate()
	print(enemies, stage)
	enemies.name = "Enemies"
	add_child(enemies)
	$StageLayout.get_child(stage).visible = true
	$StageLayout.get_child(stage).collision_enabled = true

func _process(delta):
	timer += delta
	if timer > 25 and get_child(8).find_child("Boss").get_child_count() == 0:
		print("Win")

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
