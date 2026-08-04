extends Area2D

var projectile_damage = 1.0
@onready var shooting_point = get_parent()
var travel_distance = 0

func _ready():
	$AnimatedSprite2D.play("default")

func _physics_process(delta):
	global_rotation = shooting_point.global_rotation
	global_position = shooting_point.global_position


func _on_body_entered(body:):
	if body.has_method("take_damage"):
		if "defense" in body:
			body.take_damage(projectile_damage + body.defense)
		else:
			body.take_damage(projectile_damage)
		


func _on_animated_sprite_2d_animation_finished():
	queue_free()
