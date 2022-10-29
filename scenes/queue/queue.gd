extends Node2D

onready var CUSTOMERS = get_children()
var PREV_CUSTOMERS = {"color" : [], "scale" : [], "position" : []}

const MAX_CUSTOMER_SPREAD_X = 500
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

func _ready():
	pass

func initialize():
	init_distribution()
	init_depth()
	CUSTOMERS = get_children()
	CUSTOMERS[1].current_customer = true

func _process(delta):
	if advancing:
		move_depth(delta)

func advance_line():
	if !advancing:
		CUSTOMERS = get_children()
		get_previous_customers()
		for customer in CUSTOMERS:
			customer.get_node("animation").play("walk_forward")
		advancing = true

func init_depth():
	CUSTOMERS = get_children()
	for i in CUSTOMERS.size():
		# COLOR
		var mod = CUSTOMERS[i].get_modulate()
		var r = clamp(mod[0] - COLOR_DEPTH, 0, 1)
		var g = clamp(mod[1] - COLOR_DEPTH*1.2, 0, 1)
		var b = clamp(mod[2] - COLOR_DEPTH*1.2, 0, 1)
		var color = Color(r,g,b, mod[3])
		CUSTOMERS[i].set_modulate(color)
		COLOR_DEPTH += COLOR_DEPTH_STEP
		# Z-INDEX
		CUSTOMERS[i].z_index = ROOT_Z_INDEX - i
		# SCALE
		CUSTOMERS[i].scale = Vector2(SCALE_DEPTH)
		SCALE_DEPTH = Vector2(SCALE_DEPTH.x - SCALE_DEPTH_STEP, SCALE_DEPTH.y - SCALE_DEPTH_STEP)
		SCALE_DEPTH.y = clamp(SCALE_DEPTH.y, 0, 1)

func move_depth(delta):
	CUSTOMERS = get_children()
	for i in CUSTOMERS.size():
		if i != 0:
			# MOVE TOWARDS COLOR OF NEXT CUSTOMER
			var current_color = CUSTOMERS[i].get_modulate()
			var next_color = PREV_CUSTOMERS["color"][i-1]
			var r = move_toward(current_color[0], next_color[0], delta * MODULATE_SPEED)
			var g = move_toward(current_color[1], next_color[1], delta * MODULATE_SPEED)
			var b = move_toward(current_color[2], next_color[2], delta * MODULATE_SPEED)
			var color = Color(r,g,b, 1)
			CUSTOMERS[i].set_modulate(color)
			COLOR_DEPTH += COLOR_DEPTH_STEP
			
			# SCALE
			var current_scale = CUSTOMERS[i].scale
			var next_scale = PREV_CUSTOMERS["scale"][i-1]
			var x = move_toward(current_scale.x, next_scale.x, delta * MODULATE_SPEED)
			var y = move_toward(current_scale.y, next_scale.y, delta * MODULATE_SPEED)
			CUSTOMERS[i].scale = Vector2(x, y)
			
			# POSITION
			var current_pos = CUSTOMERS[i].position
			var next_pos = PREV_CUSTOMERS["position"][i-1]
			var pos_x = move_toward(current_pos.x, next_pos.x, delta * MODULATE_SPEED * CUSTOMER_SPEED)
			var pos_y = move_toward(current_pos.y, next_pos.y, delta * MODULATE_SPEED * CUSTOMER_SPEED)
			CUSTOMERS[i].position = Vector2(pos_x, pos_y)	

	if customer_move_timer >= CUSTOMER_MOVE_TIME:
		print("DONE ADVANCING")
		CUSTOMERS[0].queue_free()
		CUSTOMERS[1].current_customer = true
		advancing = false
		customer_move_timer = 0
	customer_move_timer += delta
	
func init_distribution():
	randomize()
	CUSTOMERS = get_children()
	for customer in CUSTOMERS:
		customer.position.x += randi() % MAX_CUSTOMER_SPREAD_X
		customer.position.y += randi() % MAX_CUSTOMER_SPREAD_Y

func clear_queue():
	CUSTOMERS = get_children()
	for customer in CUSTOMERS:
		customer.queue_free()

func get_previous_customers():
	for customer in CUSTOMERS:
		PREV_CUSTOMERS.color.append(customer.get_modulate())
		PREV_CUSTOMERS.scale.append(customer.scale)
		PREV_CUSTOMERS.position.append(customer.position)

static func compare_floats(a, b, epsilon = 0.001):
	return abs(a - b) <= epsilon
