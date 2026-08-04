extends Node

var base_player_stats = [50.0, 10.0, 42.0, 0.0, 2.0]

var icons = [["Damage", 0, 125], ["Max health", 0, 125], ["Regen", 0, 125], ["Defense", 0, 125],
			["Speed", 0, 125], ["Same", 0, 125], ["Pls money", 0, 125], ["Hello.", 0, 125],
			["Pistol", -1, 200], ["Shotgun", -1, 250], ["Sword", -1, 250], ["Beam", -1, 250], 
			["Sniper", -1, 325], ["Gatling", -1, 325], ["Lantern", -1, 400], ["Sapper", -1, 400],
			["Volt", -1, 500], ["Mortar", 0, 500], ["Dagger", 0, 500], ["Katana", 0, 650],
			["Mine", -1, 650], ["Aura", -1, 1000]]
#Nessesary data for getting the icons among other things for these upgrades. Order: Name, Current level, Upgrade cost. Upgrade cost is stored here to save across scenes.

var descriptions = [
	"Increase damage by 10%", "Increase max health by 10%", "Improve regeneration by 1/s", "Reduce incoming damage by 1",
	"Increase speed by 10%", "will increase collection area but rn does nothing lol :son:", "will increase critical chance :krgzani_alternative_entity:", "will do something :grimace:", 
	["Unlock pistol \n Fires bullets towards your cursor", "Increase damage by 25%", "Reduce firerate by 20%", "Increase damage by another 25%"], 
	["Unlock shotgun \n Fires 5 bullets in a cone. Each projectile indivisually deals less damage than the pistol.", "Increase damage by 25%", "Reduce firerate by 20%", "Increase bullets per burst by 2"], 
	["Unlock sword \n Deal high damage to all enemies in an area directly in front of yourself", "Increase damage by 25%", "Reduce firerate by 20%", "Increase damage by another 25%"], 
	["Unlock beam \n Fires a beam that damages all enemies in it's path. Deals low damage and has a slow firerate.", "Increase damage by 25%", "Reduce firerate by 20%", "Increase beam width by 2x"], 
	["Unlock sniper \n Pierces through up to 5 enemies, dealing high damage to each of them. Has a very slow firerate.", "Increase damage by 25%", "Reduce firerate by 20%", "Increase piercing limit by 3"], 
	["Unlock gatling \n Fires small inaccurate bullets at a rapid pace. Deals very low damage, but fires quickly.", "Increase damage by 25%", "Reduce firerate by 20%", "Increase damage by another 25%"], 
	["Unlock lantern \n Orbits around you, damaging enemies it collides with", "Increase damage by 25%", "Increase orbit speed by 20%", "Increase orbiting lanterns by 1"], 
	["Unlock sapper \n Targets the weakest enemy on the field, rapidly draining their health. Deals very low damage, but hits very fast.", "Increase damage by 25%", "Reduce firerate by 20%", "Increase damage by another 25%"],
	["Unlock volt \n Targets the nearest enemy to yourself, and chains towards nearby enemies. Reduces damage each chain.", "Increase damage by 25%", "Reduce firerate by 20%", "Increase chain length by 3"],
	["Unlock mortar \n Fires an explosive shot to the location of your mouse cursor.", "Increase damage by 25%", "Reduce cooldown by 20%", "Increase radius by 20%"], 
	["Unlock dagger \n Swing in a small area in front very quickly. Every 6 swings, throw a dagger at the nearest enemy. Pierces.", "Increase damage by 25%", "Reduce firerate by 20%", "Reduce dagger throw requirement from 6 to 5"],
	["Unlock katana \n Slash in a wide cone, dealing moderate damage. Ignores enemy armor.", "Increase damage by 25%", "Reduce firerate by 20%", "Increase damage by another 25%"],
	["Unlock Mine \n Place a mine at your location. If an enemy steps on it, then it will create a small explosion.", "Increase damage by 25%", "Reduce firerate by 20%", "Place a 2nd mine after 1 second"],
	["Unlock aura \n aura. Deal low damage to all enemies in the effecting area.", "Increase damage by 25%", "Increase radius by 30%", "Increase damage by another 25%"]
]
#Description for the various upgrades - First 8 are for stat upgrades, others are for weapon upgrades.


var stage_data = [
	[preload("res://Stages/stage_wave/scenes/tutorial_stage.tscn"), "Tutorial", false, true],
	[preload("res://Stages/stage_wave/scenes/enemy_spawn_handler.tscn"), "Stage 1", false, true],
	[preload("res://Stages/stage_wave/scenes/handler_2.tscn"), "Stage 2", false, false],
	[preload("res://Stages/stage_wave/scenes/handler_3.tscn"), "Stage 3", false, false],
	[preload("res://Stages/stage_wave/scenes/handler_4.tscn"), "Stage 4", false, false]]
#Stage scene, stage name, check for whether stage is cleared or not.


var classes = [
	["Default", [60.0, 10.0, 42.0, 0.0, 2.0]], 
	["Attacker", [45.0, 15.0, 45.0, 0.0, 2.0]], 
	["Tanker", [85.0, 8.0, 39.0, 2.0, 3.0]], 
	["The test", [999.0, 99.0, 99.0, 9.0, 9.0]]
]
# Class name, Base stats

#var resources = [] #will use later. Purpouse is to move clear money from the game to title.
var credits = 2000000000

var selected_stage = -1
var selected_class = 0
var stage_cleared = 0
