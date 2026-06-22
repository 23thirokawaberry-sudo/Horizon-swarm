extends CharacterBody2D

var max_health = 50.0
var health = 50.0
var damage = 2.0
var regen = 1.0

var touching_enemy = false
var xp = 0
var level_xp = 5
var level = 0

signal death
signal level_up

func _ready():
	%XpBar.max_value = level_xp

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
	if level_xp == xp:
		level += 1
		level_xp += 2
		xp = 0
		level_up.emit()
	%XpBar.value = xp
	%XpBar.max_value = level_xp

func stat_upgraded():
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
