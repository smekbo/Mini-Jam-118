extends Node2D

onready var sprite = $Sprite
onready var chosen_bag_scene = preload("res://scenes/bank/chosen_bag.tscn")
onready var chosen_bag = $"../../chosen_bag"

func _input(event):
	if event is InputEventMouseButton:
		if is_clicked_on(event.position) and event.pressed:
			if chosen_bag.get_child_count() > 0:
				chosen_bag.get_child(0).queue_free()
			var bag = chosen_bag_scene.instance()
			chosen_bag.add_child(bag)
			bag.global_position = get_global_mouse_position()
			scale = Vector2(0.9, 0.9)
		if !event.pressed:
			scale = Vector2(1, 1)

func is_clicked_on(click):
	var rect = sprite.texture.get_size()
#	print([click, global_position, rect, rect/2])
	click = get_global_mouse_position()
	if click.x > sprite.global_position.x - rect.x/2 and click.x < sprite.global_position.x + rect.x/2:
		if click.y > sprite.global_position.y - rect.y/2 and click.y < sprite.global_position.y + rect.y/2:
			return true
	return false
