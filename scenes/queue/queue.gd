extends Node2D

onready var WINDOW = $"../window"

onready var CUSTOMER = $customer
onready var CUSTOMER_CONTAINER = $customers
onready var HUD = $"../camera/hud"
var CUSTOMER_LIST

var PREV_CUSTOMERS = {"color" : [], "scale" : [], "position" : []}

const MAX_CUSTOMER_SPREAD_X = 300
const MAX_CUSTOMER_SPREAD_Y = 30

const MODULATE_SPEED = 1

const CUSTOMER_SPEED = 100
var CUSTOMER_MOVE_TIME = 1
var customer_move_timer = 0

const COLOR_DEPTH_STEP = 0.1
var COLOR_DEPTH = 0
const SCALE_DEPTH_STEP = 0.05
var SCALE_DEPTH = Vector2(1, 1)
var ROOT_Z_INDEX = z_index

var advancing = false

var QUEUE_TIME = 25
var QUEUE_TIMER = 0

var CUSTOMER_WAITING = false

var DIFFICULTY_MOD = 3
var DIFFICULTY_FLAG = false

func _ready():
	WINDOW.connect("shutter_open", self, "present_first_order")
	pass

func _process(delta):
	if advancing:
		move_depth(delta)
	
	if QUEUE_TIMER >= QUEUE_TIME:
		update_list()
		CUSTOMER_LIST[0].patience_timeout()
		QUEUE_TIMER = 0
		pass

	HUD.update_timer(QUEUE_TIME - QUEUE_TIMER)

	if HUD.SCORE > 0 and HUD.SCORE % DIFFICULTY_MOD == 0 and !DIFFICULTY_FLAG:
		increase_difficulty()

	if CUSTOMER_WAITING:
		QUEUE_TIMER += delta

func increase_difficulty():
	DIFFICULTY_FLAG = true
	QUEUE_TIME -= 5
	pass

func update_list():
	CUSTOMER_LIST = CUSTOMER_CONTAINER.get_children()

func initialize():
	for x in 20:
		generate_customer(x)
	customer_distribution()
	CUSTOMER_LIST[0].current_customer = true

func present_first_order():
	CUSTOMER_LIST[0].show_order()

func customer_waiting():
	CUSTOMER_WAITING = true

func customer_done_waiting():
	CUSTOMER_WAITING = false

func generate_customer(index):
	var customer = CUSTOMER.duplicate()
	customer.connect("waiting", self, "customer_waiting")
	customer.connect("not_waiting", self, "customer_done_waiting")
	CUSTOMER_CONTAINER.add_child(customer)
	set_customer_depth(customer, index)
	customer.show()

func advance_line():
	if !advancing:
		CUSTOMER_LIST.pop_front().queue_free()
		QUEUE_TIMER = 0
		update_list()
		get_previous_customers()
		for customer in CUSTOMER_LIST:
			customer.get_node("animation").play("walk_forward")
		advancing = true

func customer_distribution():
	update_list()
	for customer in CUSTOMER_LIST:
		customer.position.x += randi() % MAX_CUSTOMER_SPREAD_X
		customer.position.y += randi() % MAX_CUSTOMER_SPREAD_Y

func set_customer_depth(customer, index):
	update_list()
	# COLOR
	var mod = CUSTOMER_LIST[index].get_modulate()
	var r = clamp(mod[0] - COLOR_DEPTH, 0, 1)
	var g = clamp(mod[1] - COLOR_DEPTH*1.2, 0, 1)
	var b = clamp(mod[2] - COLOR_DEPTH*1.2, 0, 1)
	var color = Color(r,g,b, mod[3])
	CUSTOMER_LIST[index].set_modulate(color)
	COLOR_DEPTH += COLOR_DEPTH_STEP
	# Z-INDEX
	CUSTOMER_LIST[index].z_index = ROOT_Z_INDEX - index
	# SCALE
	CUSTOMER_LIST[index].scale = Vector2(SCALE_DEPTH)
	SCALE_DEPTH = Vector2(SCALE_DEPTH.x - SCALE_DEPTH_STEP, SCALE_DEPTH.y - SCALE_DEPTH_STEP)
	SCALE_DEPTH.y = clamp(SCALE_DEPTH.y, 0, 1)

func reset_depth_counters():
	COLOR_DEPTH = 0
	SCALE_DEPTH = Vector2(1, 1)

func move_depth(delta):
	update_list()
	for i in CUSTOMER_LIST.size():
		if i != 0:
			# MOVE TOWARDS COLOR OF NEXT CUSTOMER
			var current_color = CUSTOMER_LIST[i].get_modulate()
			var next_color = PREV_CUSTOMERS["color"][i-1]
			var r = move_toward(current_color[0], next_color[0], delta * MODULATE_SPEED)
			var g = move_toward(current_color[1], next_color[1], delta * MODULATE_SPEED)
			var b = move_toward(current_color[2], next_color[2], delta * MODULATE_SPEED)
			var color = Color(r,g,b, 1)
			CUSTOMER_LIST[i].set_modulate(color)
			COLOR_DEPTH += COLOR_DEPTH_STEP
			
			# SCALE
			var current_scale = CUSTOMER_LIST[i].scale
			var next_scale = PREV_CUSTOMERS["scale"][i-1]
			var x = move_toward(current_scale.x, next_scale.x, delta * MODULATE_SPEED)
			var y = move_toward(current_scale.y, next_scale.y, delta * MODULATE_SPEED)
			CUSTOMER_LIST[i].scale = Vector2(x, y)
			
			# POSITION
			var current_pos = CUSTOMER_LIST[i].position
			var next_pos = PREV_CUSTOMERS["position"][i-1]
			var pos_x = move_toward(current_pos.x, next_pos.x, delta * MODULATE_SPEED * CUSTOMER_SPEED)
			var pos_y = move_toward(current_pos.y, next_pos.y, delta * MODULATE_SPEED * CUSTOMER_SPEED)
			CUSTOMER_LIST[i].position = Vector2(pos_x, pos_y)	

	if customer_move_timer >= CUSTOMER_MOVE_TIME:
		finish_advancing_line()
		customer_move_timer = 0
	customer_move_timer += delta

func finish_advancing_line():
	advancing = false

	CUSTOMER_LIST[0].current_customer = true
	CUSTOMER_LIST[0].show_order()	
	
	update_list()
	generate_customer(CUSTOMER_LIST.size())

	reset_depth_counters()
	for x in CUSTOMER_LIST.size():
		set_customer_depth(CUSTOMER_LIST[x], x)

func clear_queue():
	for customer in CUSTOMER_LIST:
		customer.queue_free()

func get_previous_customers():
	for customer in CUSTOMER_LIST:
		PREV_CUSTOMERS.color.append(customer.get_modulate())
		PREV_CUSTOMERS.scale.append(customer.scale)
		PREV_CUSTOMERS.position.append(customer.position)

static func compare_floats(a, b, epsilon = 0.001):
	return abs(a - b) <= epsilon
