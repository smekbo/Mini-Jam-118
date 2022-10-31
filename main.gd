extends Node2D

onready var CUSTOMER_SCENE = preload("res://scenes/customer/customer.tscn")

onready var QUEUE = $queue
onready var WINDOW = $window
onready var HUD = $camera/hud

func _ready():
	randomize()
	WINDOW.connect("shutter_open", self, "on_shutter_open")
	WINDOW.connect("shutter_closed", self, "on_shutter_closed")
	HUD.connect("game_over", self, "end_game")
	start_game()

func start_game():
	WINDOW.open()
	QUEUE.initialize()
	pass

func end_game():
	WINDOW.get_node("shutter-pivot").get_node("game_over").show()
	WINDOW.get_node("shutter-pivot").get_node("game_over").get_node("score").text = "SCORE: " + str(HUD.SCORE)
	WINDOW.close()
	pass

func on_shutter_open():
	pass

func on_shutter_closed():
	QUEUE.queue_free()
