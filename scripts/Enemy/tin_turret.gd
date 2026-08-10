extends StaticBody2D

signal fire

#basic enemy stats.
var max_health = 90.0
var health = 90.0
var damage = 3.0
const FIRERATE = [0.5, 0.5]
const BURST = 1
var cash_drop = 6.0

var touching = null #global variable for whether the enemy is touching player or not.
var is_dead = false #prevents enemy from spawning xp multiple times if multiple bullets deal a lethal blow at the same frame.
var in_range = null

const BULLET = preload("res://scenes/Enemy/mage_cast.tscn")
@onready var player  = get_node("/root/Game/Player")

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
	var true_damage = incoming_damage
	if true_damage < 1:
		true_damage = 1
	health -= true_damage
	const DAMAGE_NUMBER = preload("res://scenes/Enemy/damage_indicator.tscn")
	var new_number = DAMAGE_NUMBER.instantiate()
	new_number.scale = Vector2(0.25, 0.25)
	if get_parent().name == "Boss":
		get_parent().get_parent().find_child("DamageNumber").add_child(new_number)
	else:
		get_parent().find_child("DamageNumber").add_child(new_number)
	new_number.global_position = global_position
	new_number.display_number(true_damage)
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


func _on_attack_cooldown_timeout():
	take_damage(6)
	fire.emit()
