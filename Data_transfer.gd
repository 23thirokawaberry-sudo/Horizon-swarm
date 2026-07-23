extends Node

var base_player_stats = [50.0, 10.0, 42.0, 0.0, 2.0]

var icons = [["Damage", 0, 125], ["Max health", 0, 125], ["Regen", 0, 125], ["Defense", 0, 125],
			["Speed", 0, 125], ["Same", 0, 125], ["Pls money", 0, 125], ["Hello.", 0, 125],
			["Pistol", 0, 200], ["Shotgun", -1, 250], ["Sword", -1, 250], ["Beam", -1, 250], 
			["Sniper", -1, 325], ["Gatling", -1, 325], ["Lantern", -1, 400], ["Sapper", -1, 400]]
#Max health, Damage, Speed, Defense, Regen

var descriptions = ["Increase damage by 10%", "Increase max health by 10", "Improve regeneration by 1/s", "Reduce incoming damage by 1",
					"Increase speed by 3", "will increase collection area but rn does nothing lol :son:", "will increase critical chance :krgzani_alternative_entity:", "will do something :grimace:", 
					["Unlock pistol", "Increase damage by 25%", "Reduce firerate by 20%", "Increase damage by another 25%"], 
					["Unlock shotgun", "Increase damage by 25%", "Reduce firerate by 20%", "Increase bullets per burst by 2"], 
					["Unlock sword", "Increase damage by 25%", "Reduce firerate by 25%", "Increase damage by another 25%"], 
					["Unlock beam", "Increase damage by 25%", "Reduce firerate by 20%", "Increase beam width by 2x"], 
					["Unlock sniper", "Increase damage by 25%", "Reduce firerate by 20%", "Increase piercing limit by 2"], 
					["Unlock gatling", "Increase damage by 25%", "Reduce firerate by 20%", "Increase damage by another 25%"], 
					["Unlock lantern", "Increase damage by 25%", "Increase orbit speed by 20%", "Increase orbiting lanterns by 1"], 
					["Unlock sapper", "Increase damage by 25%", "Reduce firerate by 20%", "Increase damage by another 25%"]]


#var resources = [] #will use later. Purpouse is to move clear money from the game to title.
var credits = 2000000000

var selected_stage = -1
