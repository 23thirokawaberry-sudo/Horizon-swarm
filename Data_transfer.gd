extends Node

var base_player_stats = [50.0, 10.0, 60.0, 0.0, 2.0]

var stats = [[[0, 0], "Damage", 0, 125], [[32, 0], "Regen", 0, 125], [[0, 32], "Max health", 0, 125], 
					[[32, 32], "I do nothing", 0, 125], [[64, 0], "I also do nothing", 0, 125]]
#Max health, Damage, Speed, Defense, Regen
var weapons = [-1, 0, -1, -1, -1, -1, -1, 0]
#Weapons - Shotgun, pistol, sword, beam, sniper, gatling, lantern, sapper

#var resources = [] #will use later. Purpouse is to move clear money from the game to title.
var credits = 1000000

var selected_stage = -1
