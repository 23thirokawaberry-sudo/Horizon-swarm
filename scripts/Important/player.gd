extends CharacterBody2D

#these are base values. different classes and upgrades in menu will increase these.
@onready var base = DataTransfer.base_player_stats.duplicate(true)

#upgrades change these values
var damage_multi = 1.0

var touching_hazard = false

#full calculation for each indivisual stats
@onready var max_health = base[0]
@onready var damage = base[1]
@onready var regen = base[4]
@onready var speed = base[2]
@onready var defense = base[3]
func set_effective_stats():
	#said calculations
	damage = base[1] * damage_multi

@onready var health = max_health #sets health to max health when starting for the first time

#xp management
var xp = 0
var level_xp = 4
var level = 0

signal death
signal level_up
signal pause
var time_elapsed = 0
var boss = null

func _process(delta):
	time_elapsed += delta
	$Time.text = str(snapped(time_elapsed, 0.1))
	%XpBar.max_value = level_xp
	%HealthBar.max_value = max_health
	%HealthBar.value = health
	if get_parent().get_child(10).find_child("Boss").get_child_count() != 0:
		boss = get_parent().get_child(10).find_child("Boss").get_child(0)
		if is_instance_valid(boss):
			$BossBar.visible = true
			$BossBar.max_value = boss.max_health
			$BossBar.value = boss.health
	else:
		boss = null
		$BossBar.visible = false
	
	%Credits.text = "Credits: %0.0f" % [get_parent().credits_gain]

@warning_ignore("unused_parameter")
func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()
	
	if velocity.length() > 0.0:
		$Animations.play("walk")
	else:
		$Animations.play("idle")

func get_xp():
	if xp >= level_xp:
		leveled_up()
	%XpBar.value = xp
	%XpBar.max_value = level_xp

func leveled_up():
	level += 1
	xp -= level_xp
	level_xp += 2
	level_up.emit()

func stat_upgraded():
	set_effective_stats()
	%HealthBar.max_value = max_health
	%HealthBar.value = health

func recieve_damage(incoming_damage):
	if defense >= incoming_damage - 1:
		print("Negated")
		health -= 1
	else:
		health -= incoming_damage - defense
	%HealthBar.value = health
	if health <= 0.0:
		death.emit()

func _on_regen_timeout():
	if health > 0 and health < max_health:
		health += regen
		if health > max_health:
			health = max_health
		%HealthBar.value = health
		
func _on_pause_pressed():
	pause.emit()
	
