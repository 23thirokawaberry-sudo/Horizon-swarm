extends CharacterBody2D

var health = 1200.0
var self_damage = 100.0
var speed = 15.0
var touching = null
var is_dead = false

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
		touching.recieve_damage(self_damage)

func take_damage(damage):
	health -= damage
	damage_effect()
	
	if health <= 325:
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
			get_parent().add_child(death_anim)
			death_anim.global_position = global_position

func enrage():
	if is_enraged == false:
		speed = 25.0
		self_damage = 125.0
		is_enraged = true
		modulate = Color(3.0,0,0,1)

func damage_effect():
	if health > 550:
		modulate = Color(6.0,0.1,0.1)
		$HitTick.start(0.05)
		await $HitTick.timeout
		modulate = Color(1,1,1,1)
	else:
		modulate = Color(8.0,0.1,0.1)
		$HitTick.start(0.05)
		await $HitTick.timeout
		modulate = Color(3,0,0,1)
