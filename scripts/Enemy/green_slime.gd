extends CharacterBody2D

#basic enemy stats.
var health = 50.0
const DAMAGE = 8.0
const SPEED = 32.0

var touching = null #global variable for whether the enemy is touching player or not.
var is_dead = false #prevents enemy from spawning xp multiple times if multiple bullets deal a lethal blow at the same frame.

@onready var player  = get_node("/root/Game/Player")

func _physics_process(delta):
	#enemy movement
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * SPEED
	move_and_slide()
	
func _on_cooldown_timeout():
	#spacing between enemy damage; stops player from immediatly dying when touching an enemy.
	if touching != null:
		deal_damage()

func _on_hitbox_body_entered(body: Node2D):
	#sets touching variable to player if touching, then damages player until touching is set to null from following function.
	touching = body
	deal_damage()
	%Cooldown.start()
	
func _on_hitbox_body_exited(body: Node2D):
	#sets touching variable to null if player is no longer touching.
	if body == touching:
		if is_instance_valid(%Cooldown):
			%Cooldown.stop()
		touching = null

func deal_damage():
	#damages player
	if touching and touching.has_method("recieve_damage"):
		touching.recieve_damage(DAMAGE)

func take_damage(damage):
	health -= damage
	
	if health <= 0:
		if is_dead == false:
			is_dead = true
			if is_instance_valid(%Cooldown):
				%Cooldown.stop()
			touching = null
			queue_free()
			const DEATH_ANIM = preload("res://scenes/Important/Enemy_Death.tscn")
			var death_anim = DEATH_ANIM.instantiate()
			get_parent().add_child(death_anim)
			death_anim.global_position = global_position
