extends Area2D
#This script/scene is called by all enemies that has a projectile.

var player_in_range = []

@onready var damage = get_parent().damage
@onready var bullet = get_parent().BULLET
@onready var cooldown = get_parent().FIRERATE
@onready var burst = get_parent().BURST
@onready var timer = get_parent().find_child("AttackCooldown")
func _ready():
	timer.wait_time = cooldown[0]
	timer.start()

func _physics_process(delta):
	player_in_range = get_overlapping_bodies()
	if player_in_range.size() > 0.0:
		var target = player_in_range.front()
		look_at(target.global_position)


func _on_fire():
	if player_in_range.size() > 0.0:
		for i in range(burst):
			var new_bullet = bullet.instantiate()
			new_bullet.global_position = %ShootingPoint.global_position
			new_bullet.global_rotation = %ShootingPoint.global_rotation
			new_bullet.scale = get_parent().scale
			new_bullet.projectile_damage = damage
			find_parent("Enemies").get_child(2).get_child(1).add_child(new_bullet)
			$BurstSpacing.start()
			await $BurstSpacing.timeout
		timer.wait_time = randf_range(cooldown[0], cooldown[1])
	else:
		timer.wait_time = 0.1 #Prepares for when player enters range
	timer.start()
