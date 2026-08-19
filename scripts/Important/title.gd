extends Control

var database = DataTransfer.database

var shop_loaded = false
var database_loaded = false
var stage_loaded = false
var current_page = null
var stat_upgrade = DataTransfer.icons
var stages = DataTransfer.stage_data
const ICONS = preload("res://assets/sprites/misc/icons.png")
@onready var transition = $Transition.get_child(0).get_child(2)

func _ready():
	$Transition.find_child("CanvasLayer").visible = true
	transition.play("open")

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
	
	if stage_loaded == false:
		stage_loaded = true
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
	
	if shop_loaded == false:
		shop_loaded = true
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
				if stat[3] == true:
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
func cash_check_weapons(value):
	var stat = stat_upgrade[value + 8]
	if stat[1] < 4:
		if DataTransfer.credits >= stat[2]:
			DataTransfer.credits -= stat[2]
			stat[2] += (stat[1] + 1) * snapped(stat[2] / 4, 5) + 50
			stat[1] += 1
			if stat[1] < 4:
				%Weapons.get_child(value).get_child(1).text = "%s: level %.0f \n $%.0f" % [stat[0], stat[1], stat[2]]
			elif stat[1] == 4:
				%Weapons.get_child(value).get_child(1).text = "%s: level 4 \n MAXXED" % [stat[0]]

func _on_stage_button_pressed(button_name):
	match button_name:
		"Beginners tutorial":
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
			if DataTransfer.stage_data[4][2] == true:
				DataTransfer.selected_stage = 6
				%Start.visible = true

func _on_database_pressed():
	$Menu.visible = false
	$Database.visible = true
	current_page = $Database


func _on_difficulty_pressed():
	for stage in DataTransfer.stage_data:
		stage[2] = true
	#for weapon in DataTransfer.icons:
	#	if weapon[-1] is bool:
	#		weapon[-1] = true
	DataTransfer.credits += 100000
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


func _on_enemies_pressed():
	for child in %DatabaseEntries.get_children():
		child.queue_free()
	for entry in database["Enemies"]:
		if database["Enemies"][entry] == true:
			var new_button = Button.new()
			new_button.text = entry
			new_button.name = entry
			%DatabaseEntries.add_child(new_button)
			new_button.pressed.connect(_on_database_button_pressed.bind(new_button.name))

func _on_database_button_pressed(button_name):
	match button_name:
		"Green slime":
			%EntryText.text = "Moves towards you. \nHealth: 18 | Damage: 2 | Speed: 20 | Credits: 1 | Xp: S"
		"Blue slime":
			%EntryText.text = "Moves towards you. But faster! \nHealth: 32 | Damage: 4 | Speed: 24 | Credits: 2 | Xp: S"
		"Red slime":
			%EntryText.text = "If you see it red, run. \nHealth: 65 | Damage: 7 | Speed: 30 | Credits: 3 | Xp: M"
		"Yellow slime":
			%EntryText.text = "Doesn't really look all that yellow. \nHealth: 111 | Damage: 11 | Speed: 35 | Credits: 4 | Xp: M"
		"Black slime":
			%EntryText.text = "Really angry because he missed the bus due to being so slow. \nHealth: 600 | Damage: 20 | Speed: 12 | Credits: 20 | Xp: L \n Ability: At half health, enrages, increasing his damage by 25% and doubling his speed."
		"Tarnished purple":
			%EntryText.text = "Moves towards you slowly. Has mutative regeneration. \nHealth: 180 | Damage: 6 | Speed: 12 | Credits: 5 | Xp: M \n Ability: Regenerates 1/12 of max health every second (1/18 if boss)."
		"Tarnished turquoize":
			%EntryText.text = "Tried to be green to look more like a zombie. Chose turquoize instead since he is colorblind. \nHealth: 500 | Damage: 9 | Speed: 15 | Credits: 7 | Xp: L \n Ability: Regenerates 1/10 of max health every second (1/15 if boss)."
		"Tin robobot":
			%EntryText.text = "Moves towards you. Has defense. \nHealth: 30 | Damage: 3 | Defense: 9 \n Speed: 24 | Credits: 3 | Xp: S \n Note: Has defense (Reduces incoming damage based on defense value, down to 1 damage)."
		"Copper robobot":
			%EntryText.text = "Having a shell made of copper allows it to conduct electricity around itself better. Doesn't help though. \nHealth: 42 | Damage: 5 | Defense: 15 \n Speed: 25 | Credits: 4 | Xp: M"
		"Steel robobot":
			%EntryText.text = "Made of steel. Somehow that tiny rubber tyre can still hold and balance this heavy thing. \nHealth: 64 | Damage: 10 | Defense: 21 \n Speed: 28 | Credits: 6 | Xp: M"
		"Bluesteel robobot":
			%EntryText.text = "Made of a special alloy with mithril and iron to prevent damage from outside sources. It doesn't help the fact that the machine is hollow and can break important mechanisms from heavy blows.
			 \nHealth: 90 | Damage: 15 | Defense: 24 \n Speed: 30 | Credits: 12 | Xp: L \n Ability: At 1/5 health, Increase defense to 50"
		"Pillar":
			%EntryText.text = "Hops around your location. Acts as a solid wall, and only hurts if it lands on you. \nHealth: 1520 | Damage: 20 | Credits: 4 | Xp: S \n Ability: Stationary enemy. Behaves like a wall and can't be pushed. Enemies can't collide with it. Deals no contact damage.
			 \n Ability: Every 18 seconds, Leaps into the air and a red marker will appear on the ground around you. After 2.5 seconds, will land, dealing damage to you if you are in the landing area."
		"Blitzer":
			%EntryText.text = "Orbits you like a pest. Really unpredictable. \nHealth: 40 | Damage: 4 | Orbit speed: 1.5 | Credits: 6 | Xp: M \n Ability: Orbits around you at a far distance. 
			\n Ability: Flying enemy, immune to certain weapons. \n Ability: Fires a burst of 3 projectiles every 1-5 seconds."
		"Triangle mage":
			%EntryText.text = "Fires fireballs at you instead of firetriangles. \nHealth: 40 | Damage: 4 | Speed: 3 | Credits: 6 | Xp: S \n Ability: Fires a projectile at you every 4.5 seconds, dealing damage equal to it's own damage."
		"Tin projector":
			%EntryText.text = "Has a shield that craves for projectiles and explosions. \nHealth: 15 | Shield: 625 | Damage: 1 | Speed: 8 | Credits: 3 | Xp: M
			 \n Ability: Creates a forcefield around itself that absorbs incoming non-piercing projectiles and explosions. Will also tank attacks that hit it's main body while the shield is up. The shield will regenerate 15 seconds after it is destroyed."
		"Tin sentry":
			%EntryText.text = "Stationary enemy that fires bullets at a rapid rate. \nHealth: 90 | Damage: 3 | Credits: 1 | Xp: S \n Ability: Stationary enemy. Behaves like a wall and can't be pushed. Enemies can't collide with it. Deals no contact damage.
			 \n Ability: Fires a bullet every 0.5 seconds, dealing damage equal to itself, and taking self damage equal to double it's own damage."
		"Tin mecha":
			%EntryText.text = "Fat robot with lots of equipment. \nHealth: 2050 | Damage: 12 | Defense: 6 \n Speed: 16 | Credits: 80 | Xp: L \n Ability: Every 7.5 seconds, will stand in place before firing 2 bursts of 5 projectiles from each arm.
			 \n Ability: Every 15 seconds it will place a turret at it's position."

func _on_weapon_info_pressed():
	pass # Replace with function body.


func _on_achievements_pressed():
	pass # Replace with function body.
