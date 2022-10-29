extends Node2D

var SPEED = 2000

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse = get_global_mouse_position()
	var x =  move_toward(global_position.x, mouse.x, delta * SPEED)
	var y =  move_toward(global_position.y, mouse.y, delta * SPEED)
	
	global_position = Vector2(x, y)
