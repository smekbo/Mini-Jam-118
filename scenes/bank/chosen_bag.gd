extends Node2D

var SPEED = 2000

enum TYPES {AB_NEG, AB_POS, A_NEG, A_POS, B_NEG, B_POS, O_NEG, O_POS}
var TYPE

func set_type(type):
	TYPE = type

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
	
