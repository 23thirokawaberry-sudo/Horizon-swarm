extends Area2D

var projectile_damage = 1.0

var travel_distance = 0

func _physics_process(delta):
	const SPEED = 65.0
	const RANGE = 1000.0
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	travel_distance += SPEED * delta
	if travel_distance > RANGE:
		queue_free()

func _on_body_entered(body:):
	queue_free()
	if body.has_method("recieve_damage"):
		body.recieve_damage(projectile_damage)
