extends Area2D
func _ready():
	$AnimatedSprite2D.play("Death")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("Xp")

func _on_area_entered(area: Area2D):
	queue_free()
	var player = area.get_parent()
	print(player)
	player.xp += 100.0
	player.get_xp()
