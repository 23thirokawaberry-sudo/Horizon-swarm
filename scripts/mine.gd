extends Area2D

var projectile_damage = 1.0

var time = 0
var duration = 15
var detonated = false

var speed = 100

func _physics_process(delta):
	if speed > 0:
		var direction = Vector2.RIGHT.rotated(rotation)
		position += direction * speed * delta
		speed -= time * 8
	time += delta
	if time > duration:
		detonate()


func _on_body_entered(body:):
	detonate()
	if body.has_method("take_damage"):
		body.take_damage(projectile_damage)

func detonate():
	if detonated == false:
		speed = 0
		scale = Vector2(3.5, 3.5)
		detonated = true
		$Timer.start(1.0)

func _on_timer_timeout():
	queue_free()
