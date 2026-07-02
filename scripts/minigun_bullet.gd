extends Area2D

var projectile_damage = 1.0
var pierce = 1.0

var travel_distance = 0

func _physics_process(delta):
	const SPEED = 350.0
	const RANGE = 1500.0
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	travel_distance += SPEED * delta
	if travel_distance > RANGE:
		queue_free()


func _on_body_entered(body:):
	if pierce == 0:
		queue_free()
	pierce -= 1.0
	if body.has_method("take_damage"):
		body.take_damage(projectile_damage)
