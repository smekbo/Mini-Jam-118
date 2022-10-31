extends Node2D

signal game_over

onready var DATE = $date
onready var SCORE_DISPLAY = $customers_served
var SCORE = 0
onready var SATISFACTION_DISPLAY = $customer_satisfaction/bar
onready var TIMER = $timer

func _ready():
	DATE.text = Time.get_date_string_from_system()
	
func increase_score(amount):
	SCORE += amount
	SCORE_DISPLAY.text = str(SCORE)

func decrease_satisfaction(amount):
	SATISFACTION_DISPLAY.rect_size.x -= amount
	if SATISFACTION_DISPLAY.rect_size.x <= 0:
		emit_signal("game_over")

func increase_satisfaction(amount):
	SATISFACTION_DISPLAY.rect_size.x += amount

func update_timer(time):
	TIMER.text = str(time).substr(0, 4)
