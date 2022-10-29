extends Node2D

enum BLOOD_TYPES {AB_NEG, AB_POS, A_NEG, A_POS, B_NEG, B_POS, O_NEG, O_POS}
var BLOOD_TYPE

onready var BLOOD_TYPE_LABEL = $pivot/blood_type
onready var animation = $AnimationPlayer

var INSTRUCTIONS = [
	"Yo",
	"Hi",
	"Howdy",
	"Aw shucks",
	"One blood, please"
]
onready var INSTRUCTION_LABEL = $pivot/instructions
var INSTRUCTION

var TITLES = [
	"Blood Bank of Amelia",
	"Blub Bang of Lamelia"
]
onready var TITLE_LABEL = $pivot/bank_title
var TITLE

onready var seal = $pivot/seal
onready var photo = $pivot/photo

func _ready():
	for x in BLOOD_TYPES.size():
		print(x)


func set_photo(texture):
	photo.texture = texture

func randomize_order_data():
	TITLE = TITLES[randi() % TITLES.size()-1]
	BLOOD_TYPE = randi() % BLOOD_TYPES.size()
	INSTRUCTION = INSTRUCTIONS[randi() % INSTRUCTIONS.size()-1]
	set_order_visuals()
	
func set_order_visuals():
	TITLE_LABEL.text = TITLE
	print("TYPE %s" % get_type_string())
	BLOOD_TYPE_LABEL.text = get_type_string()
	INSTRUCTION_LABEL.text = INSTRUCTION
	
func reveal_animation():
	animation.play("reveal")


func get_type_string():
	if BLOOD_TYPE == BLOOD_TYPES.AB_NEG:
		return "AB-"
	if BLOOD_TYPE == BLOOD_TYPES.AB_POS:
		return "AB+"
	if BLOOD_TYPE == BLOOD_TYPES.A_NEG:
		return "A-"
	if BLOOD_TYPE == BLOOD_TYPES.A_POS:
		return "A+"
	if BLOOD_TYPE == BLOOD_TYPES.B_NEG:
		return "B-"
	if BLOOD_TYPE == BLOOD_TYPES.B_POS:
		return "B+"
	if BLOOD_TYPE == BLOOD_TYPES.O_NEG:
		return "O-"
	if BLOOD_TYPE == BLOOD_TYPES.O_POS:
		return "O+"
	return "ERR"
