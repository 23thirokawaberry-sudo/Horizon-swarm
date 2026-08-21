extends Node2D
var level_menu = false
var paused = false
var win_triggered = false
var gameover = false
var timer = 0
@onready var transition = $Transition.get_child(0).get_child(2)

const ENEMIES = {
	"Green slime": preload("res://scenes/Enemy/green_slime.tscn"),
	"Blue slime": preload("res://scenes/Enemy/blue_slime.tscn"),
	"Red slime": preload("res://scenes/Enemy/red_slime.tscn"),
	"Yellow slime": preload("res://scenes/Enemy/yellow_slime.tscn"),
	"Black slime": preload("res://scenes/Enemy/black_slime.tscn"),
	"Tarnished purple": preload("res://scenes/Enemy/tarnished_purple.tscn"),
	"Tarnished turquoize": preload("res://scenes/Enemy/tarnished_turquoize.tscn"),
	"Tin robobot": preload("res://scenes/Enemy/robobot.tscn"),
	"Copper robobot": preload("res://scenes/Enemy/copper_robobot.tscn"),
	"Steel robobot": preload("res://scenes/Enemy/steel_robobot.tscn"),
	"Bluesteel robobot": preload("res://scenes/Enemy/bluesteel_robobot.tscn"),
	"Sandstone pillar": preload("res://scenes/Enemy/sandstone_pillar.tscn"),
	"Marble pillar": preload("res://scenes/Enemy/pillar.tscn"),
	"Blitzer": preload("res://scenes/Enemy/blitzer.tscn"),
	"Triangle mage": preload("res://scenes/Enemy/triangle_mage.tscn"),
	"Tin projector": preload("res://scenes/Enemy/projector_mk_1.tscn"),
	"Omecha": preload("res://scenes/Enemy/tin_mecha.tscn"), 
	"Red stickman": preload("res://scenes/Enemy/red_stickman.tscn"), 
	"Green stickman": preload("res://scenes/Enemy/green_stickman.tscn"),
	"Blue stickman": preload("res://scenes/Enemy/blue_stickman.tscn")
}
#Stages will call these to spawn the enemies.

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
		%GainedMoney.text = "Credits earned: %.0f + %.0f (clear bonus 50%%)" % [credits_gain, credits_gain * 0.5]
		credits_gain *= 1.5
		for enemy in enemies.ENEMY_APPEARENCES:
			if enemy in DataTransfer.database["Enemies"]:
				DataTransfer.database["Enemies"][enemy] = true
		if "WEAPON_UNLOCK" in enemies:
			for weapon in DataTransfer.icons:
				if weapon[0] in enemies.WEAPON_UNLOCK:
					weapon[3] = true
		if stage_data[stage][2] == false:
			stage_data[stage][2] = true

func time():
	return $Enemies.time_elapsed

func _on_pause():
	if paused == false and gameover == false and level_menu == false:
		%Pause.visible = true
		paused = true
		get_tree().paused = true
	elif paused == true and gameover == false and level_menu == false:	
		%Pause.visible = false
		paused = false
		get_tree().paused = false

func _on_player_death():
	gameover = true
	%GameOver.visible = true
	get_tree().paused = true
	
func _on_button_pressed():
	DataTransfer.credits += credits_gain
	transition.play("close")
	await get_tree().create_timer(0.45).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Important/title.tscn")
