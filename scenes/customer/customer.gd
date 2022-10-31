extends Node2D

signal waiting
signal not_waiting

onready var chosen_bag = get_tree().get_current_scene().get_node("bank").get_node("chosen_bag")
onready var queue = get_tree().get_current_scene().get_node("queue")
onready var ORDER_HOLDER = get_tree().get_current_scene().get_node("order_holder")
onready var hud = get_tree().get_current_scene().get_node("camera").get_node("hud")
onready var BANK = get_tree().get_current_scene().get_node("bank")

var current_customer = false

onready var SPRITE = $Sprite
onready var PARTICLES = $CPUParticles2D
onready var ORDER = $order
onready var ANIMATION = $animation

var PORTRAITS = [
	preload("res://scenes/customer/vamp1.png"),
	preload("res://scenes/customer/vamp2.png"),
	preload("res://scenes/customer/vamp3.png")
]

var COMPATIBILITY_MATRIX = [
	["O+", "O+", "O-"],
	["O-", "O-"],
	["A+", "O+", "O-", "A+", "A-"],
	["A-", "O-", "A-"],
	["B+", "O+", "O-", "B+", "B-"],
	["B-", "O-", "B-"],
	["AB+", "O+", "O-", "A+", "A-", "B+", "B-", "AB+", "AB-"],
	["AB-", "O+", "O-", "A-", "B-", "AB-"]
]

func _ready():
	ORDER.hide()
	randomize_portrait()
	ORDER.set_photo(SPRITE.texture)
	ORDER.randomize_order_data()

func _input(event):
	if event is InputEventMouseButton:
		if is_clicked_on(event.position) and event.pressed:
			if current_customer:
				if chosen_bag.PICKED_UP:
					emit_signal("not_waiting")
					chosen_bag.put_down()
					ANIMATION.play("eat")

func randomize_portrait():
	SPRITE.texture = PORTRAITS[randi() % PORTRAITS.size()-1]

func set_current_customer():
	current_customer = true

func show_order():
	ORDER.global_position = ORDER_HOLDER.global_position
	ORDER.z_index = 100
	ORDER.show()
	ORDER.reveal_animation()
	emit_signal("waiting")

func verify_order():
	var bag = chosen_bag.get_type_string()
	var recipient = ORDER.get_type_string()
	if blood_is_compatible(bag, recipient):
		if chosen_bag.HAZARD_LEVEL == 0:
			ANIMATION.play("sick")
			hud.decrease_satisfaction(50)
		elif bag == recipient:
			ANIMATION.play("happy")
			hud.increase_score(1)
		else :
			ANIMATION.play("neutral")
			hud.increase_score(1)
	else:
		ANIMATION.play("die")
		hud.decrease_satisfaction(100)
	
	queue.DIFFICULTY_FLAG = false
	BANK.STOCK_FLAG = false
	
func patience_timeout():
	ANIMATION.play("impatient")
	hud.decrease_satisfaction(50)
	
func blood_is_compatible(donor, recipient):
	for row in COMPATIBILITY_MATRIX:
		if row[0] == recipient:
			for x in row.size():
				if x != 0:
					if donor == row[x]:
						return true
	return false

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
	queue_free()
