extends Control

var current_page = null
var stat_upgrade = DataTransfer.icons
var stages = DataTransfer.stage_data
const ICONS = preload("res://assets/sprites/misc/icons.png")
@onready var transition = $Transition.get_child(0).get_child(2)

func _ready():
	$Transition.find_child("CanvasLayer").visible = true
	transition.play("open")
	var added = 0
	var row = 0
	for stat in stat_upgrade:
		if stat_upgrade.find(stat) < 8:
			var new_button = Button.new()
			new_button.name = stat[0]
			new_button.global_position = Vector2(added * 110.0, row * 145.0)
			new_button.size = Vector2(100.0, 135.0)
			%Stats.add_child(new_button)
			var new_label = Label.new()
			var new_icon = TextureRect.new()
			var new_atlas = AtlasTexture.new()
			new_atlas.atlas = ICONS
			var icon_x = stat_upgrade.find(stat) * 32
			var icon_y = 0
			while icon_x >= 256:
				icon_x -= 256
				icon_y += 1
			new_atlas.region = Rect2(icon_x, (icon_y * 32), 32, 32)
			new_icon.texture = new_atlas
			new_icon.global_position = Vector2(0.0, 0.0)
			new_label.global_position = Vector2(0.0, 100.0)
			new_icon.size = Vector2(100.0, 100.0)
			new_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			new_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			new_label.add_theme_font_size_override("font_size", 10)
			new_label.size = Vector2(100.0, 35.0)
			if stat[1] != -1:
				new_label.text = "%s: level %.0f \n $%.0f" % [stat[0], stat[1], stat[2]]
			elif stat[1] >= 3 and stat_upgrade.find(stat) >= 8:
				new_label.text = "%s: level 3 \n MAXXED" % [stat[0]]
			else:
				new_label.text = "Unlock %s \n $%.0f" % [stat[0], stat[2]]
			new_button.add_child(new_icon)
			new_button.add_child(new_label)
			new_button.pressed.connect(_on_button_pressed.bind(new_button.name))
			added += 1
			if added == 6:
				added = 0
				row += 1
		elif stat_upgrade.find(stat) < 21:
			if stat_upgrade.find(stat) == 8:
				added = 0
				row = 0
			var new_button = Button.new()
			new_button.name = stat[0]
			new_button.global_position = Vector2(added * 110.0, row * 145.0)
			new_button.size = Vector2(100.0, 135.0)
			%Weapons.add_child(new_button)
			var new_label = Label.new()
			var new_icon = TextureRect.new()
			var new_atlas = AtlasTexture.new()
			new_atlas.atlas = ICONS
			var icon_x = stat_upgrade.find(stat) * 32
			var icon_y = 0
			while icon_x >= 256:
				icon_x -= 256
				icon_y += 1
			new_atlas.region = Rect2(icon_x, (icon_y * 32), 32, 32)
			new_icon.texture = new_atlas
			new_icon.global_position = Vector2(0.0, 0.0)
			new_label.global_position = Vector2(0.0, 100.0)
			new_icon.size = Vector2(100.0, 100.0)
			new_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			new_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			new_label.add_theme_font_size_override("font_size", 10)
			new_label.size = Vector2(100.0, 35.0)
			if stat[1] != -1:
				new_label.text = "%s: level %.0f \n $%.0f" % [stat[0], stat[1], stat[2]]
			elif stat[1] >= 3 and stat_upgrade.find(stat) >= 8:
				new_label.text = "%s: level 3 \n MAXXED" % [stat[0]]
			else:
				new_label.text = "Unlock %s \n $%.0f" % [stat[0], stat[2]]
			new_button.add_child(new_icon)
			new_button.add_child(new_label)
			new_button.pressed.connect(_on_button_pressed.bind(new_button.name))
			added += 1
			if added == 6:
				added = 0
				row += 1
	
	for stage in stages:
		var new_button = Button.new()
		new_button.name = stage[1]
		new_button.text = stage[1]
		new_button.custom_minimum_size = Vector2(200, 0)
		if stage[2] == false:
			if stage[3] == false:
				new_button.modulate = Color(0.75, 0.75, 0.75, 1)
			else:
				new_button.modulate = Color(0, 0, 0, 1)
		else:
			new_button.modulate = Color(0.75, 0.6, 0.25, 1)
		%Stages.add_child(new_button)
		new_button.pressed.connect(_on_stage_button_pressed.bind(new_button.name))
		

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

func _on_start_pressed():
	if DataTransfer.selected_stage != -1:
		transition.play("close")
		await get_tree().create_timer(0.45).timeout
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
		"Damage":
			var stat = stat_upgrade[0]
			if DataTransfer.credits >= stat[2]:
				DataTransfer.credits -= stat[2]
				stat[2] += (stat[1] + 1) * 25
				stat[1] += 1
				%Stats.get_child(0).get_child(1).text = "%s: level %.0f \n $%.0f" % [stat[0], stat[1], stat[2]]
		"Max health":
			var stat = stat_upgrade[1]
			if DataTransfer.credits >= stat[2]:
				DataTransfer.credits -= stat[2]
				stat[2] += (stat[1] + 1) * 25
				stat[1] += 1
				%Stats.get_child(1).get_child(1).text = "%s: level %.0f \n $%.0f" % [stat[0], stat[1], stat[2]]
		"Regen":
			var stat = stat_upgrade[2]
			if DataTransfer.credits >= stat[2]:
				DataTransfer.credits -= stat[2]
				stat[2] += (stat[1] + 1) * 25
				stat[1] += 1
				%Stats.get_child(2).get_child(1).text = "%s: level %.0f \n $%.0f" % [stat[0], stat[1], stat[2]]
		"Defense":
			var stat = stat_upgrade[3]
			if DataTransfer.credits >= stat[2]:
				DataTransfer.credits -= stat[2]
				stat[2] += (stat[1] + 1) * 25
				stat[1] += 1
				%Stats.get_child(3).get_child(1).text = "%s: level %.0f \n $%.0f" % [stat[0], stat[1], stat[2]]
		"Speed":
			var stat = stat_upgrade[4]
			if DataTransfer.credits >= stat[2]:
				DataTransfer.credits -= stat[2]
				stat[2] += (stat[1] + 1) * 25
				stat[1] += 1
				%Stats.get_child(4).get_child(1).text = "%s: level %.0f \n $%.0f" % [stat[0], stat[1], stat[2]]
		"Pistol":
			cash_check_weapons(0)
		"Shotgun":
			cash_check_weapons(1)
		"Sword":
			cash_check_weapons(2)
		"Beam":
			cash_check_weapons(3)
		"Sniper":
			cash_check_weapons(4)
		"Gatling":
			cash_check_weapons(5)
		"Lantern":
			cash_check_weapons(6)
		"Sapper":
			cash_check_weapons(7)
		"Volt":
			cash_check_weapons(8)
		"Mortar":
			cash_check_weapons(9)
		"Dagger":
			cash_check_weapons(10)
		"Katana":
			cash_check_weapons(11)
		"Mine":
			cash_check_weapons(12)
	$Shop/cash.text = "Credits: %.0f" % [DataTransfer.credits]

func _on_stage_button_pressed(button_name):
	match button_name:
		"Tutorial":
			DataTransfer.selected_stage = 0
			%Start.visible = true
		"Stage 1":
			DataTransfer.selected_stage = 1
			%Start.visible = true
		"Stage 2":
			if DataTransfer.stage_data[1][2] == true:
				DataTransfer.selected_stage = 2
				%Start.visible = true
		"Stage 3":
			if DataTransfer.stage_data[1][2] == true:
				DataTransfer.selected_stage = 3
				%Start.visible = true
		"Stage 4":
			if DataTransfer.stage_data[2][2] == true and DataTransfer.stage_data[3][2] == true:
				DataTransfer.selected_stage = 4
				%Start.visible = true
		"Stage 5":
			if DataTransfer.stage_data[4][2] == true:
				DataTransfer.selected_stage = 5
				%Start.visible = true
		"Stage 6":
			if DataTransfer.stage_data[5][2] == true:
				DataTransfer.selected_stage = 6
				%Start.visible = true
func _on_database_pressed():
	$Menu.visible = false
	$Database.visible = true
	current_page = $Database

func cash_check_weapons(value):
	var stat = stat_upgrade[value + 8]
	if stat[1] < 3:
		if DataTransfer.credits >= stat[2]:
			DataTransfer.credits -= stat[2]
			stat[2] += (stat[1] + 1) * 150
			stat[1] += 1
			if stat[1] < 3:
				%Weapons.get_child(value).get_child(1).text = "%s: level %.0f \n $%.0f" % [stat[0], stat[1], stat[2]]
			elif stat[1] == 3:
				%Weapons.get_child(value).get_child(1).text = "%s: level 3 \n MAXXED" % [stat[0]]

func _on_difficulty_pressed():
	for stage in DataTransfer.stage_data:
		stage[2] = true
		stage[3] = true
	for info in DataTransfer.icons:
		info[1] += 4
	get_tree().reload_current_scene()


func _on_stats_pressed():
	%Stats.visible = true
	%Weapons.visible = false
	%Classes.visible = false

func _on_weapons_pressed():
	%Stats.visible = false
	%Weapons.visible = true
	%Classes.visible = false

func _on_classes_pressed():
	%Stats.visible = false
	%Weapons.visible = false
	%Classes.visible = true


func _on_default_pressed():
	DataTransfer.selected_class = 0
func _on_attacker_pressed():
	DataTransfer.selected_class = 1
func _on_tank_pressed():
	DataTransfer.selected_class = 2
func _on_the_test_pressed():
	DataTransfer.selected_class = 3
