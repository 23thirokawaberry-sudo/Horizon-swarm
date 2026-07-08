extends Line2D

var projectile_damage = 1.0
var firerate = 0.1

var duration = 0

func _physics_process(delta):
	duration += delta
	if duration > firerate:
		queue_free()
