extends CharacterBody2D

var max_health = 50.0
var health = 50.0

signal death

@warning_ignore("unused_parameter")
func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 68
	move_and_slide()
	
	if velocity.length() > 0.0:
		$Animations.play("walk")
	else:
		$Animations.play("idle")
	
	var incoming_damage = 4.0
	var overlapping_mobs = %Hurtbox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= incoming_damage * overlapping_mobs.size() * delta
		%ProgressBar.value = health
		if health <= 0.0:
			death.emit()

func _on_regen_timeout():
	if health > 0 and health < max_health:
		health += 1
		%ProgressBar.value = health
