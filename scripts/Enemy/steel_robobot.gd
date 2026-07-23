extends CharacterBody2D

#basic enemy stats.
var max_health = 64.0
var health = 60.0
var damage = 10.0
const SPEED = 28.0
const DEFENSE = 21.0
var cash_drop = 6.0

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
		touching.recieve_damage(damage)

func take_damage(incoming_damage):
	var true_damage = (incoming_damage - DEFENSE)
	if true_damage > 1:
		health -= true_damage
	else:
		health -= 1
	damage_effect()
	
	if health <= 0:
		if is_dead == false:
				is_dead = true
				if is_instance_valid(%Cooldown):
					%Cooldown.stop()
				touching = null
				queue_free()
				const DEATH_ANIM = preload("res://scenes/Important/Enemy_Death.tscn")
				var death_anim = DEATH_ANIM.instantiate()
				if get_parent().name == "Boss":
					get_parent().get_parent().find_child("Xp").add_child(death_anim)
				else:
					get_parent().find_child("Xp").add_child(death_anim)
				death_anim.global_position = global_position
				get_node("/root/Game").credits_gain += cash_drop

func damage_effect():
	modulate = Color(6.0,0.1,0.1)
	$HitTick.start(0.05)
	await $HitTick.timeout
	modulate = Color(1,1,1,1)
	
