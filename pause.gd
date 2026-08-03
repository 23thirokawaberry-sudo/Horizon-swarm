extends CanvasLayer

signal pause

@onready var weapon_details = get_parent().find_child("Player").find_child("Gun").weapon_levels
@onready var icon_positions = DataTransfer.icons.duplicate(true)
var position_given = [false, false, false, false, false, false, false, false, false]
const ICONS = preload("res://assets/sprites/misc/icons.png")
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
		if weapon_details[i][1] != -1:
			if position_given[i] == false:
				position_given[i] = true
				var icon = i + 8
				var new_group = Control.new()
				new_group.custom_minimum_size = Vector2(250.0, 75.0)
				$ColorRect/ScrollContainer/VSplitContainer.add_child(new_group)
				var new_textbox = Label.new()
				var new_icon = TextureRect.new()
				var new_atlas = AtlasTexture.new()
				new_atlas.atlas = ICONS
				var icon_x = icon * 32
				var icon_y = 0
				while icon_x >= 256:
					icon_x -= 256
					icon_y += 1
				new_atlas.region = Rect2(icon_x, icon_y * 32, 32, 32)
				new_icon.texture = new_atlas
				new_icon.global_position = Vector2(0.0, 0.0)
				new_textbox.global_position = Vector2(75.0, 0.0)
				new_icon.size = Vector2(75.0, 75.0)
				new_textbox.size = Vector2(175.0, 75.0)
				entries.append([new_textbox, i]) #the textbox, the position of the nessesary details of the weapon
				new_textbox.text = "weapon name : level %d" % [weapon_details[i][1]]
				new_group.add_child(new_icon)
				new_group.add_child(new_textbox)
			for entry in entries:
				if entry[1] == i:
					entry[0].text = "weapon name : level %d" % [weapon_details[i][1]]

	
