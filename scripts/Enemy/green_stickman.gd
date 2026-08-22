extends CharacterBody2D

#basic enemy stats.
var buffed = 0
var max_health = 30.0
var health = 30.0
var resistance = 20
var damage = 4.0
var speed = 28.0
var cash_drop = 2.0

var touching = null #global variable for whether the enemy is touching player or not.
var is_dead = false #prevents enemy from spawning xp multiple times if multiple bullets deal a lethal blow at the same frame.

@onready var handler = find_parent("Enemies")
@onready var player  = get_node("/root/Game/Player")
@onready var sprite = $AnimatedSprite2D

func _physics_process(delta):
	#enemy movement
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	if direction.x < 0:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
		
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
	health -= incoming_damage * ((100 - resistance) * 0.01)
	const DAMAGE_NUMBER = preload("res://scenes/Enemy/damage_indicator.tscn")
	var new_number = DAMAGE_NUMBER.instantiate()
	new_number.scale = Vector2(0.25, 0.25)
	if get_parent().name == "Boss":
		get_parent().get_parent().find_child("DamageNumber").add_child(new_number)
	else:
		get_parent().find_child("DamageNumber").add_child(new_number)
	new_number.global_position = global_position
	new_number.display_number(incoming_damage * ((100 - resistance) * 0.01))
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
			for child in handler.get_children():
				check_loop(child)
			for child in handler.find_child("Boss").get_children():
				check_loop(child)
					
				

func check_loop(selected):
	if "buffed" in selected:
		if selected.buffed < 10:
			selected.max_health *= 1.2
			selected.health += selected.max_health * 0.35
			if selected.health > selected.max_health:
				selected.health = selected.max_health
			selected.sprite.modulate = Color(0.0,6.0,0.0)
			selected.find_child("FlashTick").start(0.05)
			selected.buffed += 1

func damage_effect():
	sprite.modulate = Color(6.0,0.1,0.1)
	$HitTick.start(0.05)
	await $HitTick.timeout
	sprite.modulate = Color(1,1,1,1)


func _on_flash_tick_timeout():
	sprite.modulate = Color(1,1,1,1)
