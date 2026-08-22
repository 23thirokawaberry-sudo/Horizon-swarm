extends Node

var base_player_stats = [50.0, 10.0, 42.0, 0.0, 2.0]

var icons = [["Damage", 0, 125], ["Max health", 0, 125], ["Regen", 0, 125], ["Defense", 0, 125],
			["Speed", 0, 125], ["Same", 0, 125], ["Pls money", 0, 125], ["Hello.", 0, 125],
			["Pistol", 0, 200, true], ["Shotgun", -1, 250, true], ["Sword", -1, 250, true], ["Beam", -1, 250, true], 
			["Sniper", -1, 325, true], ["Gatling", -1, 325, true], ["Lantern", -1, 400, true], ["Sapper", -1, 400, true],
			["Volt", -1, 500, true], ["Mortar", -1, 500, false], ["Dagger", -1, 500, false], ["Katana", -1, 650, false],
			["Mine", -1, 650, false], ["Aura", -1, 1000, false]]
#Nessesary data for getting the icons among other things for these upgrades. Order: Name, Current level, Upgrade cost. Upgrade cost is stored here to save across scenes.

var descriptions = [
	"Increase damage by 10%", "Increase max health by 10%", "Improve regeneration by 1/s", "Reduce incoming damage by 1",
	"Increase speed by 10%", "will increase collection area but rn does nothing lol :son:", "will increase critical chance :krgzani_alternative_entity:", "will do something :grimace:", 
	["Unlock pistol \n Fires bullets towards your cursor. Deals 100% of your damage.", "Increase damage. \n Damage: 1x > 1.25x", "Reduce firerate. \n Firerate: 1x > 0.8x", "Increase damage. \n Damage: 1.25x > 1.5x", "Increase size and damage. \n Size: 1x > 1.25x \n Damage: 1.5x > 1.65x", "Bullets can now pierce once."], 
	["Unlock shotgun \n Fires 5 bullets in a cone. Each projectile indivisually deals 75% of your damage.", "Increase damage \n Damage: 1x > 1.25x", "Reduce firerate \n Firerate: 1x > 0.8x", "Increase bullets per burst by 2", "Improve all stats. \n Damage: 1.5x > 1.65x \n Firerate: 0.8x > 0.7x \n Bullets: 7 > 8 \n Accuracy: 0.6 > 0.5", "Reduce bullets by 2 and increase firerate by 40% but fire in bursts of 2"], 
	["Unlock sword \n Deal 150% of your damage to all enemies in an area directly in front of yourself", "Increase damage \n Damage: 1x > 1.25x", "Reduce firerate \n Firerate: 1x > 0.8x", "Increase damage \n Damage: 1.25 > 1.5x", "Increase firerate and significantly increase damage \n Damage: 1.5 > 2.1 \n Firerate: 0.8 > 1.0", "Swing additionally behind yourself. Also increases damage by 10%"], 
	["Unlock beam \n Fires a beam that damages all enemies in it's path. Deals 80% of your damage.", "Increase damage \n Damage: 1x > 1.25x", "Reduce firerate \n Firerate: 1x > 0.8x", "Increase beam width \n Width: 1x > 1.5x", "Reduce firerate further \n Firerate: 0.8 > 0.5", "Reduce damage by 75% but fire 3 beams."], 
	["Unlock sniper \n Pierces through up to 5 enemies, dealing 180% of your damage to each of them. Has a very slow firerate.", "Increase damage by 25%", "Reduce firerate by 20%", "Increase piercing limit by 3", "Increase piercing limit by 1 and Increase damage by 30%", "Increase bullet size by 40%"], 
	["Unlock gatling \n Fires small inaccurate bullets at a rapid pace. Deals 30% of your damage, but fires very quickly.", "Increase damage by 25%", "Reduce firerate by 25%", "Increase damage by another 25%", "Reduce firerate by another 20% and improve accuracy by 0.05%"], 
	["Unlock lantern \n Orbits around you, dealing 80% of your damage to enemies it collides with.", "Increase damage by 25%", "Increase orbit speed by 20%", "Increase orbiting lanterns by 1", "Increase damage by 10% and increase size of lanterns by 25%"], 
	["Unlock sapper \n Targets the weakest enemy on the field, rapidly draining their health. Deals 10% of your damage, but hits extremely fast. Cannot target stationary enemies.", "Increase damage by 25%", "Reduce firerate by 20%", "Increase damage by another 25%", "Increase damage by another 40%"],
	["Unlock volt \n Targets the nearest enemy to yourself, and chains towards nearby enemies. Deals 50% of your damage, and reduces damage by 15% per chain. Cannot chain to stationary enemies.", "Increase damage by 25%", "Reduce firerate by 20%", "Increase chain length by 3", "Reduce damage loss per chain by 8% and increase damage by 16%"],
	["Unlock mortar \n Fires an explosive shot to the location of your mouse cursor, dealing 200% of your damage.", "Increase damage by 25%", "Reduce cooldown by 15%", "Increase radius by 20%", "Increase explosion lingering by 30% and reduce cooldown by 10%"], 
	["Unlock dagger \n Swing in a small area in front very quickly, dealing 80% of your damage. Every 6 swings, throw a dagger at the nearest enemy. Pierces.", "Increase damage by 25%", "Reduce firerate by 20%", "Reduce dagger throw requirement from 6 to 5", "Increase damage by 40%"],
	["Unlock katana \n Slash in a wide cone, dealing 125% of your damage. Ignores enemy armor.", "Increase damage by 25%", "Reduce firerate by 20%", "Increase damage by another 25%", "Increase damage area by 15% and damage by 15%.", "Deal additional damage equal to 10% of the enemy's defense."],
	["Unlock Mine \n Place a mine at your location. If it collides with anything, it will create a small explosion that deals 100% of your damage to enemies in the area.", "Increase damage by 25%", "Reduce firerate by 20%", "Place a 2nd mine after 1 second", "Increase mine lifetime by 30% and damage by 25%", "Increase mine explosion radius by 50%. Also increase mine tossing radius and reduce cooldown by 15%."],
	["Unlock aura \n afat.duud im not finishing this when there is less than a week left and not even the icon is done", "Increase damage by 25%", "Increase radius by 30%", "Increase damage by another 25%", "stinky aura", "smelly aura"]
]
#Description for the various upgrades - First 8 are for stat upgrades, others are for weapon upgrades.


var stage_data = [
	[preload("res://Stages/stage_wave/scenes/guide_stage_1.tscn"), "Beginners tutorial", false, 0],
	[preload("res://Stages/stage_wave/scenes/handler_1.tscn"), "Stage 1", false, 0],
	[preload("res://Stages/stage_wave/scenes/handler_2.tscn"), "Stage 2", false, 1],
	[preload("res://Stages/stage_wave/scenes/handler_3.tscn"), "Stage 3", false, 1],
	[preload("res://Stages/stage_wave/scenes/guide_stage_2.tscn"), "the", false, 1],
	[preload("res://Stages/stage_wave/scenes/handler_4.tscn"), "Stage 4", false, 2],
	[preload("res://Stages/stage_wave/scenes/handler_5.tscn"), "Stage 5", false, 1], 
	[preload("res://Stages/stage_wave/scenes/handler_6.tscn"), "Stage 6", false, 1],
	[preload("res://Stages/stage_wave/scenes/handler_7.tscn"), "Stage 7", false, 1]]
#Stage scene, stage name, check for whether stage is cleared or not.


var classes = [
	["Default", [60.0, 10.0, 42.0, 0.0, 2.0]], 
	["Attacker", [45.0, 15.0, 45.0, 0.0, 2.0]], 
	["Tanker", [85.0, 8.0, 39.0, 2.0, 3.0]], 
	["The test", [999.0, 99.0, 99.0, 9.0, 9.0]]
]
# Class name, Base stats

var database = {"Enemies": {
	"Green slime": false, "Blue slime": false, "Red slime": false, "Yellow slime": false, "Black slime": false, 
	"Tarnished purple": false, "Tarnished turquoize": false, "Tin robobot": false, "Copper robobot": false,
	"Steel robobot": false, "Bluesteel robobot": false, "Sandstone pillar": false, "Marble pillar": false, "Blitzer": false,
	"Triangle mage": false, "Tin projector": false, "Tin sentry": false, "Tin mecha": false
}, "Locations": {
	"Spire": true
}}
#Entries for the database. Values will change between false and true based on stage clears.

#var resources = [] #will use later. Purpouse is to move clear money from the game to title.
var credits = 150

var selected_stage = -1
var selected_class = 0
var stage_cleared = 0
