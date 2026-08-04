extends Node2D
var level_menu = false
var paused = false
var win_triggered = false
var timer = 0
@onready var transition = $Transition.get_child(0).get_child(2)


var credits_gain = 0

var stage = DataTransfer.selected_stage

var enemies = null

var stage_data = DataTransfer.stage_data

func _ready():
	transition.play("open")
	enemies = stage_data[stage][0].instantiate()
	enemies.name = "Enemies"
	add_child(enemies)

func _process(delta):
	timer += delta
	if timer > enemies.win_time and enemies.find_child("Boss").get_child_count() == 0 and win_triggered == false:
		win_triggered = true
		%Win.visible = true
		get_tree().paused = true
		%GainedMoney.text = "%.0f + %.0f Credits gained" % [credits_gain, credits_gain * 0.5]
		credits_gain *= 1.5
		if stage_data[stage][2] == false:
			stage_data[stage][2] = true

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
