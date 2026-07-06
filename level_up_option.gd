extends CanvasLayer

@onready var buttons = [$Button, $Button2, $Button3]
var upgrade_option = 0

signal level_up_selected
@onready var defense_check = DataTransfer.base_player_stats[3]

#this will need a lot of explaining
var stat_upgrade = [[[0, 0], "Damage up", 1], [[32, 0], "Regen up", 2], [[0, 32], "Max health up", 3], 
					[[32, 32], "Speed up", 4], [[64, 0], "Defense up", 5]] #Stat upgrades - they can be upgraded indefinetally.
var weapon_upgrade = [[[192, 0], "Shotgun unlock", 6], [[224, 32], "Pistol unlock", 7], [[224, 0], "Sword unlock", 8], 
					[[192, 32], "Beam unlock", 9], [[192, 64], "Sniper unlock", 10], [[224, 64], "Gatling unlock", 11]] #Weapon upgrades - each weapon has a certain max level, after which they no longer can be upgraded.
# @onready var weapon_info = get_parent().find_child("Player").find_child("Gun").weapon_levels
var already_picked = []

var random_upgrade = [stat_upgrade, weapon_upgrade] #puts the above lists into a single list so that random selection can select either branches.
var selected_type = 0 #variable that selects random option from random_upgrade
var selected_pos = 0 #variable for selecting random spot in list
var available_limit = [4, 5] #each position in this list relates to the highest possible value in their indivisual lists.
var selected_randomizer_range = 1 #value to select stat upgrade or weapon upgrade. 

func randomize_buttons():
	already_picked = []
	#called when the button is pressed. will return with the upgrade type and value. Weapon upgrades will be handled elsewhere as it behaves differently from stat upgrades, but for now it will do nothing
	#checks whether there are still available weapon upgrades. if so, randomly selects one.
	randomize_button(buttons[0])
	randomize_button(buttons[1])
	randomize_button(buttons[2])
func randomize_button(button):
	if selected_randomizer_range > 0:
		selected_type = randi_range(0, selected_randomizer_range)
	else:
		selected_type = 0
	#randomly selects available upgrade option
	selected_pos = randi_range(0, available_limit[selected_type])
	#changes the texture and text for the button to the values relating to the list.
	var RTP = random_upgrade[selected_type][selected_pos] #optimization
	if RTP[2] in already_picked: #Checks whether option has already been chosen
		randomize_button(button)
	else:
		if RTP[2] == 5 and defense_check <= 0: #Checks whether player has defense
			randomize_button(button)
		else:
			button.get_node("TextureRect").texture.region = Rect2(RTP[0][0], RTP[0][1], 32, 32)
			button.get_node("Label").text = RTP[1]
			already_picked.append(RTP[2])

func limited_upgrades(button):
	print("later")

func _on_button_pressed():
	upgrade_option = already_picked[0]
	level_up_selected.emit()
	already_picked = []
	randomize_buttons()

func _on_button_2_pressed():
	upgrade_option = already_picked[1]
	level_up_selected.emit()
	already_picked = []
	randomize_buttons()
	
func _on_button_3_pressed():
	upgrade_option = already_picked[2]
	level_up_selected.emit()
	already_picked = []
	randomize_buttons()

func _ready():
	randomize_buttons()
