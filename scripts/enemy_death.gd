extends Area2D

const SOUND = preload("res://scenes/Important/xp_sound.tscn")

func _ready():
	$AnimatedSprite2D.play("Death")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("Xp")

func _on_area_entered(area: Area2D):
	var new_sound = SOUND.instantiate()
	get_parent().add_child(new_sound)
	queue_free()
	var player = area.get_parent()
	print(player)
	player.xp += 1.0
	player.get_xp()
