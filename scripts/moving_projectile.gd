extends Area2D

var projectile_damage = 1.0
var attack_duration = 0.0
@onready var shooting_point = get_parent()
var travel_distance = 0

func _physics_process(delta):
	global_rotation = shooting_point.global_rotation
	global_position = shooting_point.global_position
	attack_duration += delta
	if attack_duration >= 0.5:
		queue_free()


func _on_body_entered(body:):
	if body.has_method("take_damage"):
		body.take_damage(projectile_damage)
