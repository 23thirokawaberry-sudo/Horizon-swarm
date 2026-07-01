extends CanvasLayer

signal pause

@onready var weapon_details = get_parent().find_child("Player").find_child("Gun").weapon_levels
@onready var icon_positions = get_parent().find_child("LevelUp").weapon_upgrade
var position_given = [false, false, false, false]
const ICONS = preload("res://assets/sprites/misc/Upgrade Spritesheet.png")
var entries = []


func _on_button_pressed():
	if get_parent().level_menu == false:
		pause.emit()
		new_entry()

func _process(delta):
	if get_parent().level_menu == false:
		if Input.is_action_just_pressed("pause"):
			pause.emit()
			new_entry()


func new_entry():
	for i in range(weapon_details.size()):
		if weapon_details[i] != -1:
			if position_given[i] == false:
				position_given[i] = true
				print(weapon_details[i], i)
				var icon_xy = icon_positions[i][0]
				var new_textbox = Label.new()
				var new_icon = TextureRect.new()
				var new_atlas = AtlasTexture.new()
				new_atlas.atlas = ICONS
				new_atlas.region = Rect2(icon_xy[0], icon_xy[1], 32, 32)
				new_icon.texture = new_atlas
				var spacing = entries.size() * 80.0
				new_icon.global_position = Vector2(20.0, 100.0 + spacing)
				new_textbox.global_position = Vector2(95.0, 100.0 + spacing)
				new_icon.size = Vector2(75.0, 75.0)
				new_textbox.size = Vector2(150.0, 75.0)
				entries.append([new_textbox, i]) #the textbox, the position of the nessesary details of the weapon
				new_textbox.text = "weapon name : level %d" % [weapon_details[i]]
				$ColorRect.add_child(new_icon)
				$ColorRect.add_child(new_textbox)
			for entry in entries:
				if entry[1] == i:
					entry[0].text = "weapon name : level %d" % [weapon_details[i]]

	
