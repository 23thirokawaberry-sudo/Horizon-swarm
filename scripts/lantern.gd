extends Area2D

var selected_formation = "pattern1"

var projectile_damage = 1.0

@onready var shooting_point = get_parent()
var travel_distance = 0
var spin = 1.5
var lantern_size = 2.0

func _ready():
	for child in get_children():
		if child.is_in_group(selected_formation):
			child.scale = Vector2(lantern_size, lantern_size)
			print(lantern_size)
			print(child.scale)
		else:
			child.queue_free()

func _physics_process(delta):
	global_position = shooting_point.global_position
	rotation += spin * delta


func _on_body_entered(body:):
	if body.has_method("take_damage"):
		body.take_damage(projectile_damage)
