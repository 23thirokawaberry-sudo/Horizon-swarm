extends CanvasLayer

@onready var buttons = [[$Button, 0], [$Button2, 0], [$Button3, 0]]
var upgrade_option = 0

signal level_up_selected

#this will need a lot of explaining
var stat_upgrade = [[[0, 0], "Damage up", 1], [[32, 0], "Regen up", 2], [[0, 32], "Max health up", 3]] #Stat upgrades - they can be upgraded indefinetally.
var weapon_upgrade = [[[192, 0], "Shotgun unlock", 4], [[224, 32], "Pistol unlock", 5], [[224, 0], "Sword unlock", 6], [[192, 32], "Beam unlock", 7]] #Weapon upgrades - each weapon has a certain max level, after which they no longer can be upgraded.
# var unlocked_weapon = [["Shotgun", 0], ["Sword", 0], ["Beam", 0], ["Pistol", 0]] #counts how many times the weapon has been upgraded, before removing it from the available list(s). Currently unusued.

var random_upgrade = [stat_upgrade, weapon_upgrade] #puts the above lists into a single list so that random selection can select either branches.
var selected_type = 0 #variable that selects random option from random_upgrade
var selected_pos = 0 #variable for selecting random spot in list
var available_limit = [2, 3] #each position in this list relates to the highest possible value in their indivisual lists.
var selected_randomizer_range = 1 #value to select stat upgrade or weapon upgrade. 

func randomize_button():
	#called when the button is pressed. will return with the upgrade type and value. Weapon upgrades will be handled elsewhere as it behaves differently from stat upgrades, but for now it will do nothing
	#checks whether there are still available weapon upgrades. if so, randomly selects one.
	for button in buttons:
		if selected_randomizer_range > 0:
			selected_type = randi_range(0, selected_randomizer_range)
		else:
			selected_type = 0
		#randomly selects available upgrade option
		selected_pos = randi_range(0, available_limit[selected_type])
		#changes the texture and text for the button to the values relating to the list.
		var RTP = random_upgrade[selected_type][selected_pos] #optimization
		button[0].get_node("TextureRect").texture.region = Rect2(RTP[0][0], RTP[0][1], 32, 32)
		button[0].get_node("Label").text = RTP[1]
		button[1] = RTP[2] #prepares the choices

		
func limited_upgrades(button):
	print("later")

func _on_button_pressed():
	upgrade_option = buttons[0][1]
	print(upgrade_option)
	level_up_selected.emit()
	randomize_button()

func _on_button_2_pressed():
	upgrade_option = buttons[1][1]
	level_up_selected.emit()
	randomize_button()
	
func _on_button_3_pressed():
	upgrade_option = buttons[2][1]
	level_up_selected.emit()
	randomize_button()

func _ready():
	randomize_button()
