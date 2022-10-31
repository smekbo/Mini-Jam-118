extends Node2D

onready var HUD = $"../camera/hud"

var STOCK_MOD = 5
var STOCK_FLAG = false

func _process(delta):
	if HUD.SCORE > 0 and HUD.SCORE % STOCK_MOD == 0 and !STOCK_FLAG:
		increase_stock()
	pass

func _input(event):
	if event is InputEventMouseButton:
		if is_sprite_clicked_on($hazardous_waste, event.position) and event.pressed:
			if $chosen_bag.PICKED_UP:
				$chosen_bag.put_down()
			pass

func increase_stock():
	STOCK_FLAG = true
	for bag in $bags.get_children():
		print(bag.get_children())
		bag.REMAINING += 1
		bag.update_display()

func is_sprite_clicked_on(sprite, click):
	var rect = sprite.texture.get_size()
#	print([click, global_position, rect, rect/2])
	click = get_global_mouse_position()
	if click.x > sprite.global_position.x - rect.x/2 and click.x < sprite.global_position.x + rect.x/2:
		if click.y > sprite.global_position.y - rect.y/2 and click.y < sprite.global_position.y + rect.y/2:
			return true
	return false
