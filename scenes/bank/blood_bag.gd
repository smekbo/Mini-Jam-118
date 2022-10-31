extends Node2D

onready var sprite = $Sprite
onready var chosen_bag_scene = preload("res://scenes/bank/chosen_bag.tscn")
onready var chosen_bag = $"../../chosen_bag"
onready var sfx = $AudioStreamPlayer

enum TYPES {AB_NEG, AB_POS, A_NEG, A_POS, B_NEG, B_POS, O_NEG, O_POS}
export(TYPES) var TYPE

export var REMAINING = 2

func _ready():
	update_display()

func _input(event):
	if event is InputEventMouseButton:
		if is_clicked_on(event.position) and event.pressed:
			if !chosen_bag.PICKED_UP and REMAINING > 0:
				sfx.play()
				grab_chosen_bag()
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

func grab_chosen_bag():
	chosen_bag.pick_up(TYPE)	
	chosen_bag.global_position = get_global_mouse_position()
	REMAINING -= 1
	update_display()

func update_display():
	$count.text = str(REMAINING)

func increase_remaining(amount):
	REMAINING += amount
