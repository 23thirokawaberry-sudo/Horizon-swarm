extends Area2D
func _ready():
	$AnimatedSprite2D.play("Death")

	
	
func _on_body_entered(body:):
	queue_free()
