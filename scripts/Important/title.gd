extends Control
var current_page = null
var stat_upgrade = DataTransfer.stats
const ICONS = preload("res://assets/sprites/misc/icon.png")
var stat_buttons = []

func _ready():
	for stat in stat_upgrade:
		var new_button = Button.new()
		new_button.name = stat[1]
		var spacing = %Stats.get_child_count() * 110.0
		new_button.global_position = Vector2(20.0 + spacing, 100.0)
		new_button.size = Vector2(100.0, 135.0)
		%Stats.add_child(new_button)
		var new_label = Label.new()
		var new_icon = TextureRect.new()
		var new_atlas = AtlasTexture.new()
		new_atlas.atlas = ICONS
		new_atlas.region = Rect2(stat[0][0], stat[0][1], 32, 32)
		new_icon.texture = new_atlas
		new_icon.global_position = Vector2(0.0, 0.0)
		new_label.global_position = Vector2(0.0, 100.0)
		new_icon.size = Vector2(100.0, 100.0)
		new_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		new_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		new_label.add_theme_font_size_override("font_size", 10)
		new_label.size = Vector2(100.0, 35.0)
		new_label.text = "%s: level %.0f \n $%.0f" % [stat[1], stat[2], stat[3]]
		new_button.add_child(new_icon)
		new_button.add_child(new_label)
		new_button.pressed.connect(_on_button_pressed.bind(new_button.name))

func _on_play_pressed():
	$Label.visible = false
	$Menu.visible = true
	%Start.visible = false
	current_page = $Menu
func _on_back_pressed():
	current_page.visible = false
	if current_page == $Stages:
		%Start.visible = false
	DataTransfer.selected_stage = -1
	$Menu.visible = true
	current_page = $Menu

func _on_stages_pressed():
	$Menu.visible = false
	$Stages.visible = true
	current_page = $Stages
func _on_stage_1_pressed():
	DataTransfer.selected_stage = 0
	%Start.visible = true
func _on_stage_2_pressed():
	DataTransfer.selected_stage = 1
	%Start.visible = true
func _on_stage_3_pressed():
	DataTransfer.selected_stage = 2
	%Start.visible = true
func _on_start_pressed():
	if DataTransfer.selected_stage != -1:
		get_tree().change_scene_to_file("res://Stages/stage_map/scenes/game.tscn")

func _on_shop_pressed():
	$Menu.visible = false
	$Shop.visible = true
	current_page = $Shop
	$Shop/cash.text = "Credits: %.0f" % [DataTransfer.credits]
	%Stats.visible = true
	%Weapons.visible = false
	%Classes.visible = false
func _on_button_pressed(button_name):
	match button_name:
		"Max health":
			var stat = stat_upgrade[2]
			if DataTransfer.credits >= stat[3]:
				DataTransfer.base_player_stats[0] += 10
				DataTransfer.credits -= stat[3]
				stat[3] += (stat[2] + 1) * 25
				stat[2] += 1
				%Stats.get_child(2).get_child(1).text = "%s: level %.0f \n $%.0f" % [stat[1], stat[2], stat[3]]
		"Damage":
			var stat = stat_upgrade[0]
			if DataTransfer.credits >= stat[3]:
				DataTransfer.base_player_stats[1] += 1
				DataTransfer.credits -= stat[3]
				stat[3] += (stat[2] + 1) * 25
				stat[2] += 1
				%Stats.get_child(0).get_child(1).text = "%s: level %.0f \n $%.0f" % [stat[1], stat[2], stat[3]]
		"Speed":
			DataTransfer.base_player_stats[2] += 3
		"Defense":
			DataTransfer.base_player_stats[3] += 1
		"Regen":
			var stat = stat_upgrade[1]
			if DataTransfer.credits >= stat[3]:
				DataTransfer.base_player_stats[4] += 1
				DataTransfer.credits -= stat[3]
				stat[3] += (stat[2] + 1) * 25
				stat[2] += 1
				%Stats.get_child(1).get_child(1).text = "%s: level %.0f \n $%.0f" % [stat[1], stat[2], stat[3]]
	$Shop/cash.text = "Credits: %.0f" % [DataTransfer.credits]
	

func _on_database_pressed():
	$Menu.visible = false
	$Database.visible = true
	current_page = $Database


func _on_difficulty_pressed():
	pass # Replace with function body.
