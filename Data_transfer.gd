extends Node

var base_player_stats = [50.0, 10.0, 60.0, 0.0, 2.0]

var icons = [["Damage", 0, 125], ["Max health", 0, 125], ["Regen", 0, 125], ["I do nothing", 0, 125],
			["I also do nothing", 0, 125], ["Same", 0, 125], ["Pls money", 0, 125], ["Hello.", 0, 125],
			["Pistol", 0, 200], ["Shotgun", -1, 250], ["Sword", -1, 250], ["Beam", -1, 250], 
			["Sniper", -1, 325], ["Gatling", -1, 325], ["Lantern", -1, 400], ["Sapper", -1, 400]]
#Max health, Damage, Speed, Defense, Regen

#var resources = [] #will use later. Purpouse is to move clear money from the game to title.
var credits = 1000000

var selected_stage = -1
