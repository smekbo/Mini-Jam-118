extends Node2D

onready var CUSTOMER_SCENE = preload("res://scenes/customer/customer.tscn")

onready var QUEUE = $queue

func _ready():
	generate_customers()

func generate_customers():
	QUEUE.clear_queue()
	for x in 25:
		var customer = CUSTOMER_SCENE.instance()
		customer.initialize()
		QUEUE.add_child(customer)
	QUEUE.initialize()
