extends CanvasLayer

@onready var buttons = [$Button, $Button2, $Button3]
var upgrade_option = 0

signal level_up_selected
#this will need a lot of explaining
var upgrades = DataTransfer.icons.duplicate(true) #Weapon upgrades - each weapon has a certain max level, after which they no longer can be upgraded.
# @onready var weapon_info = get_parent().find_child("Player").find_child("Gun").weapon_levels
var description = DataTransfer.descriptions
var already_picked = []

var selected_pos = 0 #variable for selecting random spot in list

func randomize_buttons():
	already_picked = []
	#called when the button is pressed. will return with the upgrade type and value. Weapon upgrades will be handled elsewhere as it behaves differently from stat upgrades, but for now it will do nothing
	#checks whether there are still available weapon upgrades. if so, randomly selects one.
	randomize_button(buttons[0])
	randomize_button(buttons[1])
	randomize_button(buttons[2])

func randomize_button(button):
	var upgrade_type = randi_range(0, 1) #Weapons are less likely to appear
	var selected = 0
	if upgrade_type == 0:
		selected = randi_range(0, 4) #stats
	elif upgrade_type == 1:
		selected = randi_range(8, 16)#weapons
	if upgrades[selected][0] in already_picked: #Checks whether option has already been chosen
		randomize_button(button)
	elif upgrades[selected][1] >= 3 and upgrade_type == 1: #checks whether weapon is level 3, if so then loops
		randomize_button(button)
	else:
		var icon_x = selected * 32
		var icon_y = 0
		while icon_x >= 256:
			icon_x -= 256
			icon_y += 1
		button.find_child("TextureRect").texture.region = Rect2(icon_x, icon_y * 32, 32, 32)
		button.find_child("Name").text = upgrades[selected][0]
		if selected < 8:
			button.find_child("Description").text = description[selected]
		else:
			button.find_child("Description").text = description[selected][upgrades[selected][1] + 1]
		already_picked.append(upgrades[selected][0])

func limited_upgrades(button):
	print("later")

func _on_button_pressed():
	button_pressed(0)
	
func _on_button_2_pressed():
	button_pressed(1)
	
func _on_button_3_pressed():
	button_pressed(2)

func button_pressed(button_number):
	for item in upgrades:
		if already_picked[button_number] in item:
			upgrade_option = upgrades.find(item)
	level_up_selected.emit()
	already_picked = []
	randomize_buttons()

func _ready():
	randomize_buttons()
