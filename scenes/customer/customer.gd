extends Node2D

onready var chosen_bag = get_tree().get_current_scene().get_node("bank").get_node("chosen_bag")
onready var queue = get_tree().get_current_scene().get_node("queue")
onready var ORDER_HOLDER = get_tree().get_current_scene().get_node("order_holder")

var current_customer = false

onready var SPRITE = $Sprite
onready var PARTICLES = $CPUParticles2D
onready var ORDER = $order
onready var ANIMATION = $animation

func _ready():
	ORDER.hide()
	ORDER.set_photo(SPRITE.texture)
	ORDER.randomize_order_data()

func _input(event):
	if event is InputEventMouseButton:
		if is_clicked_on(event.position) and event.pressed:
			if current_customer:
				if chosen_bag.get_child_count() > 0:
					chosen_bag.get_child(0).queue_free()
					PARTICLES.emitting = true
					verify_order(chosen_bag.get_child(0))
					
					

func set_current_customer():
	current_customer = true

func show_order():
	ORDER.global_position = ORDER_HOLDER.global_position
	ORDER.show()
	ORDER.reveal_animation()
	ORDER.z_index = 20

func verify_order(chosen_bag):
	if chosen_bag.get_type_string() == ORDER.get_type_string():
		ANIMATION.play("happy")
	if chosen_bag.get_type_string() != ORDER.get_type_string():
		ANIMATION.play("die")

func is_clicked_on(click):
	var rect = SPRITE.texture.get_size()
#	print([click, global_position, rect, rect/2])
	click = get_global_mouse_position()
	if click.x > SPRITE.global_position.x - rect.x/2 and click.x < SPRITE.global_position.x + rect.x/2:
		if click.y > SPRITE.global_position.y - rect.y/2 and click.y < SPRITE.global_position.y + rect.y/2:
			return true
	return false

func advance_line():
	queue.advance_line()
