extends Area2D
#This script/scene is called by all enemies that has a projectile.

@onready var damage = get_parent().DAMAGE
@onready var bullet = get_parent().BULLET
func _ready():
	$AttackCooldown.wait_time = get_parent().FIRERATE

func _physics_process(delta):
	var player_in_range = get_overlapping_bodies()
	if player_in_range.size() > 0.0:
		var target = player_in_range.front()
		look_at(target.global_position)

func _on_attack_cooldown_timeout():
	var new_bullet = bullet.instantiate()
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation
	new_bullet.projectile_damage = damage
	self.get_parent().add_child(new_bullet)
