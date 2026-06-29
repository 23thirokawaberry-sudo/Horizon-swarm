extends CharacterBody2D

#these are base values. different classes and upgrades in menu will increase these.
var base_max_health = 500.0
var base_damage = 15.0
var base_regen = 8.0

#upgrades change these values
var damage_multi = 1.0
var max_health_multi = 1.0
var regen_multi = 1.0

#full calculation for each indivisual stats
var max_health = 500.0
var damage = 15.0
var regen = 8.0
func set_effective_stats():
	#said calculations
	max_health = base_max_health * max_health_multi
	damage = base_damage * damage_multi
	regen = base_regen * regen_multi

var health = max_health #sets health to max health when starting for the first time

#xp management
var xp = 0
var level_xp = 5
var level = 0

signal death
signal level_up

func _ready():
	%XpBar.max_value = level_xp
	%HealthBar.max_value = max_health
	%HealthBar.value = health

@warning_ignore("unused_parameter")
func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 68
	move_and_slide()
	
	if velocity.length() > 0.0:
		$Animations.play("walk")
	else:
		$Animations.play("idle")

func get_xp():
	if xp >= level_xp:
		leveled_up()
	print(xp)
	%XpBar.value = xp
	%XpBar.max_value = level_xp

func leveled_up():
	level += 1
	xp -= 5 + (level * 2)
	level_xp += (level + 1)
	level_up.emit()

func stat_upgraded():
	set_effective_stats()
	%HealthBar.max_value = max_health
	%HealthBar.value = health

func recieve_damage(incoming_damage):
	health -= incoming_damage
	%HealthBar.value = health
	if health <= 0.0:
		death.emit()

func _on_regen_timeout():
	if health > 0 and health < max_health:
		health += regen
		if health > max_health:
			health = max_health
		%HealthBar.value = health
