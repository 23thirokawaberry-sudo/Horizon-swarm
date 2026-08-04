extends Area2D

var projectile_damage = 1.0
var firerate = 1
var duration = 0

func _physics_process(delta):
	duration += delta
	if duration > firerate:
		queue_free()

func _on_body_entered(body:):
	if body.has_method("take_damage"):
		body.take_damage(projectile_damage)
