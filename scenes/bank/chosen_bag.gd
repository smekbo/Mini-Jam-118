extends Node2D

var SPEED = 2000

onready var chosen_bag_detail = $"../chosen_bag_detail"

enum TYPES {AB_NEG, AB_POS, A_NEG, A_POS, B_NEG, B_POS, O_NEG, O_POS}
var TYPE

var PROPERTIES = [
	"diabetic",
	"narc_stimulant",
	"narc_depressant"
]
var PROPERTY

var EXPIRATION

var HAZARD_LEVEL
var HAZARD_LABELS = [
	preload("res://scenes/bank/warning-label-hazard.png"),
	preload("res://scenes/bank/warning-label-safe.png"),
	preload("res://scenes/bank/warning-label-safe.png"),
	preload("res://scenes/bank/warning-label-safe.png"),
	preload("res://scenes/bank/warning-label-safe.png")
]
var HAZARD_LABEL

var PICKED_UP = false

func _ready():
	chosen_bag_detail.hide()
	hide()

func pick_up(type):
	PICKED_UP = true
	TYPE = type
	randomize_data()
	chosen_bag_detail.show()
	show()
	
func put_down():
	PICKED_UP = false
	chosen_bag_detail.hide()
	hide()
	
func randomize_data():
	PROPERTY = PROPERTIES[randi() % PROPERTIES.size()-1]
	HAZARD_LEVEL = randi() % HAZARD_LABELS.size()-1
	var time = (Time.get_unix_time_from_system() + ((randi() % 2592000) - 1296000))
	EXPIRATION = Time.get_date_string_from_unix_time(time)
	set_bag_detail()
	pass

func set_bag_detail():
	modulate = Color("ffffff")
	chosen_bag_detail.get_node("blood_type").text = get_type_string()
	chosen_bag_detail.get_node("warning_label").texture = HAZARD_LABELS[HAZARD_LEVEL]
	chosen_bag_detail.get_node("properties").text = PROPERTY
	chosen_bag_detail.get_node("expiration_date").text = "EXP: " + EXPIRATION
	if HAZARD_LEVEL == 0:
		modulate = Color("daffda")
	pass

func _process(delta):
	var mouse = get_global_mouse_position()
	var x =  move_toward(global_position.x, mouse.x, delta * SPEED)
	var y =  move_toward(global_position.y, mouse.y, delta * SPEED)
	
	global_position = Vector2(x, y)

func get_type_string():
	if TYPE == TYPES.AB_NEG:
		return "AB-"
	if TYPE == TYPES.AB_POS:
		return "AB+"
	if TYPE == TYPES.A_NEG:
		return "A-"
	if TYPE == TYPES.A_POS:
		return "A+"
	if TYPE == TYPES.B_NEG:
		return "B-"
	if TYPE == TYPES.B_POS:
		return "B+"
	if TYPE == TYPES.O_NEG:
		return "O-"
	if TYPE == TYPES.O_POS:
		return "O+"
	
func display_bag_details():
	chosen_bag_detail.get_node("blood_type").text = get_type_string()
	pass
