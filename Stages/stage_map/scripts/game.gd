extends Node2D
var level_menu = false
var paused = false
var win_triggered = false
var timer = 0
@onready var transition = $Transition.get_child(0).get_child(2)


var credits_gain = 0

var stage = DataTransfer.selected_stage

var enemies = null

const STAGE_DATA = [
	preload("res://Stages/stage_wave/scenes/enemy_spawn_handler.tscn"),
	preload("res://Stages/stage_wave/scenes/handler_2.tscn"),
	preload("res://Stages/stage_wave/scenes/handler_3.tscn"),
	preload("res://Stages/stage_wave/scenes/handler_4.tscn")]

func _ready():
	transition.play("open")
	enemies = STAGE_DATA[stage].instantiate()
	print(enemies, stage)
	enemies.name = "Enemies"
	add_child(enemies)
	$StageLayout.get_child(stage).visible = true
	$StageLayout.get_child(stage).collision_enabled = true

func _process(delta):
	timer += delta
	if timer > enemies.win_time and enemies.find_child("Boss").get_child_count() == 0 and win_triggered == false:
		win_triggered = true
		%Win.visible = true
		get_tree().paused = true
		credits_gain *= 1.5
		%GainedMoney.text = "%.0f Credits gained" % [credits_gain]

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
	DataTransfer.credits += credits_gain
	transition.play("close")
	await get_tree().create_timer(0.45).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Important/title.tscn")
