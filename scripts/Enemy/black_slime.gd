extends CharacterBody2D

var max_health = 600.0
var health = 600.0
var damage = 20.0
var speed = 16.0
var touching = null
var is_dead = false
var cash_drop = 20.0

var is_enraged = false

@onready var player  = get_node("/root/Game/Player")

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()
	
func _on_cooldown_timeout():
	if touching != null:
		deal_damage()

func _on_hitbox_body_entered(body: Node2D):
	touching = body
	deal_damage()
	%Cooldown.start()
	
func _on_hitbox_body_exited(body: Node2D):
	if body == touching:
		if is_instance_valid(%Cooldown):
			%Cooldown.stop()
		touching = null

func deal_damage():
	if touching and touching.has_method("recieve_damage"):
		touching.recieve_damage(damage)

func take_damage(incoming_damage):
	health -= incoming_damage
	damage_effect()
	
	if health <= max_health / 2:
		enrage()
	
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

func enrage():
	if is_enraged == false:
		speed = 24.0
		damage = 25.0
		is_enraged = true
		modulate = Color(3.0,0,0,1)

func damage_effect():
	if health > max_health / 2:
		modulate = Color(6.0,0.1,0.1)
		$HitTick.start(0.05)
		await $HitTick.timeout
		modulate = Color(1,1,1,1)
	else:
		modulate = Color(8.0,0.1,0.1)
		$HitTick.start(0.05)
		await $HitTick.timeout
		modulate = Color(3,0,0,1)
