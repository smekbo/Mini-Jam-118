extends Node2D

var TYPES = ["AB_NEG", "AB_POS", "A_NEG", "A_POS", "B_NEG", "B_POS", "O_NEG", "O_POS"]
var BLOOD_TYPE
onready var chosen_bag = get_tree().get_current_scene().get_node("bank").get_node("chosen_bag")
onready var queue = get_tree().get_current_scene().get_node("queue")

var current_customer = false

onready var SPRITE = $Sprite
onready var PARTICLES = $CPUParticles2D

func _input(event):
	if event is InputEventMouseButton:
		if is_clicked_on(event.position) and event.pressed:
			if current_customer:
				if chosen_bag.get_child_count() > 0:
					PARTICLES.emitting = true
					queue.advance_line()
					chosen_bag.get_child(0).queue_free()

func set_current_customer():
	print("OH OKAY")
	current_customer = true

func initialize():
	BLOOD_TYPE = generate_blood_type()
	
func generate_blood_type():
	return TYPES[randi() % TYPES.size()-1]

func is_clicked_on(click):
	var rect = SPRITE.texture.get_size()
#	print([click, global_position, rect, rect/2])
	click = get_global_mouse_position()
	if click.x > SPRITE.global_position.x - rect.x/2 and click.x < SPRITE.global_position.x + rect.x/2:
		if click.y > SPRITE.global_position.y - rect.y/2 and click.y < SPRITE.global_position.y + rect.y/2:
			return true
	return false
