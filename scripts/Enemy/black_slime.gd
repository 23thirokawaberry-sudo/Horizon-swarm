extends CharacterBody2D

var health = 41.0
const DAMAGE = 11.0
const SPEED = 25.0

@onready var player  = get_node("/root/Game/Player")

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * SPEED
	move_and_slide()
	
func take_damage(damage):
	health -= damage
	
	if health <= 0:
		queue_free()
		const DEATH_ANIM = preload("res://scenes/Enemy_Death.tscn")
		var death_anim = DEATH_ANIM.instantiate()
		get_parent().add_child(death_anim)
		death_anim.global_position = global_position
