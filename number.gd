extends Control
const number_image = preload("res://assets/sprites/misc/Numbers..png")
var transparency_level = 1.8

func display_number(number):
	number = int(ceil(number))
	print(number)
	for numbers in str(abs(number)):
		var current = int(numbers)
		var new_texture = TextureRect.new()
		var new_atlas = AtlasTexture.new()
		new_atlas.atlas = number_image
		if current < 8:
			new_atlas.region = Rect2((current * 16) + 3, 0, 10, 16)
		else:
			new_atlas.region = Rect2(((current - 8) * 16) + 3, 16, 10, 16)
		new_texture.texture = new_atlas
		%HBoxContainer.add_child(new_texture)
		$Timer.start()


func _on_timer_timeout():
	transparency_level -= 0.1
	if transparency_level < 1:
		modulate.a = transparency_level
	if transparency_level <= 0:
		queue_free()
