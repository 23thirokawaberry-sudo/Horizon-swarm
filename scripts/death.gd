extends Area2D

const SOUND = preload("res://assets/sounds/effects/XpCollect.wav")

func _ready():
	$AnimatedSprite2D.play("Death")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("Xp")

func _on_area_entered(area: Area2D):
	var new_audio = AudioStreamPlayer2D.new()
	new_audio.stream = SOUND
	get_parent().add_child(new_audio)
	new_audio.play()
	queue_free()
	var player = area.get_parent()
	player.xp += 3.0
	player.get_xp()
