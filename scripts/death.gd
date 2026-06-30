extends Area2D
func _ready():
	$AnimatedSprite2D.play("Death")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("Xp")

func _on_body_entered(body: Node2D):
	queue_free()
	body.xp += 3.0
	body.get_xp()
