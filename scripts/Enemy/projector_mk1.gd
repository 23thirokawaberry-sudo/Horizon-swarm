extends CharacterBody2D

#basic enemy stats.
var max_health = 25.0
var health = 25.0
var shield_base = 625.0
var shield = 625.0
var damage = 1.0
const SPEED = 8.0
var cash_drop = 3.0

var shielded = true

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
	if shielded == true:
		shield -= incoming_damage
	else:
		health -= incoming_damage
		damage_effect()
	const DAMAGE_NUMBER = preload("res://scenes/Enemy/damage_indicator.tscn")
	var new_number = DAMAGE_NUMBER.instantiate()
	new_number.scale = Vector2(0.25, 0.25)
	if get_parent().name == "Boss":
		get_parent().get_parent().find_child("DamageNumber").add_child(new_number)
	else:
		get_parent().find_child("DamageNumber").add_child(new_number)
	new_number.global_position = global_position
	new_number.display_number(incoming_damage)
	
	if shield <= 0 and shielded == true:
		%ShieldRecovery.start()
		$Shield.visible = false
		$Shield.set_deferred("monitorable", false)
		$Shield.set_deferred("monitoring", false)
		await get_tree().process_frame
		shielded = false
	
	if health <= 0:
		if is_dead == false:
				is_dead = true
				if is_instance_valid(%Cooldown):
					%Cooldown.stop()
				touching = null
				queue_free()
				const DEATH_ANIM = preload("res://scenes/Important/death.tscn")
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


func _on_shield_recovery_timeout():
	
	$Shield.visible = true
	$Shield.set_deferred("monitorable", true)
	$Shield.set_deferred("monitoring", true)
	$Shield.scale = Vector2(5, 5)
	shield = shield_base
	shielded = true
	


func _on_shield_area_entered(area: Area2D):
	take_damage(area.projectile_damage)
	area.queue_free()
