extends StaticBody2D

var max_health = 720.0
var health = 720.0
var damage = 18.0
var cash_drop = 4.0

var target_pos = null

var touching = null #global variable for whether the enemy is touching player or not.
var is_dead = false #prevents enemy from spawning xp multiple times if multiple bullets deal a lethal blow at the same frame.

@onready var player  = get_node("/root/Game/Player")
@onready var sprite = $Pillar

func _ready():
	$Pillar.visible = false
	$marker.visible = true
	$hitbox.set_deferred("disabled", true)
	random_pos()
	$Airborne.start()

func _on_movement_timeout():
	$Pillar.visible = false
	$marker.visible = true
	$hitbox.set_deferred("disabled", true)
	random_pos()
	$Airborne.start()

func _on_airborne_timeout():
	$Pillar.visible = true
	$marker.visible = false
	deal_damage()
	$hitbox.set_deferred("disabled", false)
	$Movement.start()

func random_pos():
	var angle = randf_range(0.0, TAU)
	var distance = randf_range(0, 100)
	var direction = Vector2.RIGHT.rotated(angle)
	global_position = player.global_position + (distance * direction)

func _on_landing_zone_body_entered(body: Node2D):
	touching = body
func _on_landing_zone_body_exited(body: Node2D):
	touching = null

func deal_damage():
	if touching and touching.has_method("recieve_damage"):
		touching.recieve_damage(damage)
		touching = null

func take_damage(incoming_damage):
	health -= incoming_damage
	const DAMAGE_NUMBER = preload("res://scenes/Enemy/damage_indicator.tscn")
	var new_number = DAMAGE_NUMBER.instantiate()
	new_number.scale = Vector2(0.25, 0.25)
	if get_parent().name == "Boss":
		get_parent().get_parent().find_child("DamageNumber").add_child(new_number)
	else:
		get_parent().find_child("DamageNumber").add_child(new_number)
	new_number.global_position = global_position
	new_number.display_number(incoming_damage)
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
	sprite.modulate = Color(6.0,0.1,0.1)
	$HitTick.start(0.05)
	await $HitTick.timeout
	sprite.modulate = Color(1,1,1,1)
