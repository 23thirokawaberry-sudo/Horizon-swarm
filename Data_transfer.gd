extends Node

var base_player_stats = [50.0, 10.0, 42.0, 0.0, 2.0]

var icons = [["Damage", 0, 125], ["Max health", 0, 125], ["Regen", 0, 125], ["Defense", 0, 125],
			["Speed", 0, 125], ["Same", 0, 125], ["Pls money", 0, 125], ["Hello.", 0, 125],
			["Pistol", 0, 200], ["Shotgun", -1, 250], ["Sword", -1, 250], ["Beam", -1, 250], 
			["Sniper", -1, 325], ["Gatling", -1, 325], ["Lantern", -1, 400], ["Sapper", -1, 400]]
#Max health, Damage, Speed, Defense, Regen

var descriptions = ["Increase damage by 10%", "Increase max health by 10", "Improve regeneration by 1/s", "Reduce incoming damage by 1",
					"Increase speed by 3", "will increase collection area but rn does nothing lol :son:", "will increase critical chance :krgzani_alternative_entity:", "will do something :grimace:", 
					["Unlock pistol \n Fires bullets towards your cursor", "Increase damage by 25%", "Reduce firerate by 20%", "Increase damage by another 25%"], 
					["Unlock shotgun \n Fires 5 bullets in a cone. Each projectile indivisually deals less damage than the pistol.", "Increase damage by 25%", "Reduce firerate by 20%", "Increase bullets per burst by 2"], 
					["Unlock sword \n Deal high damage to all enemies in an area directly in front of yourself", "Increase damage by 25%", "Reduce firerate by 20%", "Increase damage by another 25%"], 
					["Unlock beam \n Fires a beam that damages all enemies in it's path. Deals low damage and has a slow firerate.", "Increase damage by 25%", "Reduce firerate by 20%", "Increase beam width by 2x"], 
					["Unlock sniper \n Pierces through up to 5 enemies, dealing high damage to each of them. Has a very slow firerate.", "Increase damage by 25%", "Reduce firerate by 20%", "Increase piercing limit by 3"], 
					["Unlock gatling \n Fires small inaccurate bullets at a rapid pace. Deals very low damage, but fires quickly.", "Increase damage by 25%", "Reduce firerate by 20%", "Increase damage by another 25%"], 
					["Unlock lantern \n Orbits around you, damaging enemies it collides with", "Increase damage by 25%", "Increase orbit speed by 20%", "Increase orbiting lanterns by 1"], 
					["Unlock sapper \n Targets the weakest enemy on the field, rapidly draining their health. Deals very low damage, but hits very fast.", "Increase damage by 25%", "Reduce firerate by 20%", "Increase damage by another 25%"]]


#var resources = [] #will use later. Purpouse is to move clear money from the game to title.
var credits = 2000000000

var selected_stage = -1
