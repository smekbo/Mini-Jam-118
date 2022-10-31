extends Spatial

var SPEED = 0.5
var increment = 1
onready var vamps = $vamps
onready var vamp = $vamps/vamp

var PORTRAITS = [
	preload("res://scenes/customer/vamp1.png"),
	preload("res://scenes/customer/vamp2.png"),
	preload("res://scenes/customer/vamp3.png"),
	preload("res://scenes/customer/customer_ps.png")
]

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in 50:
		var newvamp = vamp.duplicate()
		var inc = increment * x
		newvamp.texture = PORTRAITS[randi() % PORTRAITS.size()-1]
		newvamp.translation = Vector3(newvamp.translation.x - inc , newvamp.translation.y, newvamp.translation.z - inc)
		vamps.add_child(newvamp)
	vamps.rotation = Vector3(0, 25, 0)
	pass # Replace with function body.

func _process(delta):
	var speed = SPEED * delta
	vamps.translation = Vector3(vamps.translation.x + speed * 0.8, vamps.translation.y, vamps.translation.z + speed)

func _on_start_pressed():
	get_tree().change_scene("res://main.tscn")
	pass # Replace with function body.

func _on_tutorial_pressed():
	vamps.hide()
	$tutorial.show()
	$Control.hide()
	$exit_tutorial.show()

func _on_exit_tutorial_pressed():
	vamps.show()
	$tutorial.hide()
	$Control.show()
	$exit_tutorial.hide()


func _on_credits_pressed():
	vamps.hide()
	$credits.show()
	$Control.hide()
	$exit_credits.show()
	pass # Replace with function body.


func _on_exit_credits_pressed():
	vamps.show()
	$credits.hide()
	$Control.show()
	$exit_credits.hide()
	pass # Replace with function body.
