extends Area2D

@onready var damage = get_parent().DAMAGE

func _physics_process(delta):
	var player_in_range = get_overlapping_bodies()
	if player_in_range.size() > 0.0:
		var target = player_in_range.front()
		look_at(target.global_position)

func _on_attack_cooldown_timeout():
	const BULLET = preload("res://scenes/Enemy/mage_cast.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotation
	new_bullet.projectile_damage = damage
	self.get_parent().add_child(new_bullet)
