extends Sprite

const SWITCH_SPEED = 10

onready var camera = $"../camera"
enum VIEW {WINDOW, BANK}
export(VIEW) var current_view

var moving = false
var original_button_position = global_position
var camera_target = 0
var button_target = 0

var debug_print_timer = 0

func _process(delta):
	if moving:
		move_camera(delta)
		move_button(delta)
		var camera_done_moving = compare_floats(camera.global_position.x, camera_target)
		var button_done_moving = compare_floats(global_position.x, button_target)
		if camera_done_moving and button_done_moving:
			set_modulate("ffffff")
			moving = false
			toggle_state()

	if debug_print_timer >= 1:
#		print([camera.global_position.x, camera_target, global_position.x, button_target])
		debug_print_timer = 0
	debug_print_timer += delta

func _input(event):
	if event is InputEventMouseButton:
		if is_clicked_on(event.position) and event.pressed:
			set_modulate("767676")
			scale = Vector2(0.6, 0.6)
			change_view()
		if !event.pressed:
			scale = Vector2(1, 1)

func move_camera(delta):
	var move_amount = 0
	var current_speed = abs(camera.global_position.x - camera_target) * SWITCH_SPEED
	
	move_amount = move_toward(camera.global_position.x, camera_target, current_speed * delta)
	
	camera.global_position.x = move_amount

func move_button(delta):
	var move_amount = 0
	var current_speed = abs(global_position.x - button_target) * SWITCH_SPEED
	
	move_amount = move_toward(global_position.x, button_target, current_speed * delta)
	
	global_position.x = move_amount

func toggle_state():
	if current_view == VIEW.WINDOW:
		current_view = VIEW.BANK
	else: 
		current_view = VIEW.WINDOW

func is_clicked_on(click):
	if !moving:
		var rect = texture.get_size()
	#	print([click, global_position, rect, rect/2])
		click = get_global_mouse_position()
		if click.x > global_position.x - rect.x and click.x < global_position.x + rect.x/2:
			if click.y > global_position.y - rect.y/2 and click.y < global_position.y + rect.y/2:
				return true
	return false

func change_view():
	moving = true
	if current_view == VIEW.WINDOW:
		camera_target = camera.global_position.x - ProjectSettings.get("display/window/size/width")
		button_target = -150
	else:
		camera_target = camera.global_position.x + ProjectSettings.get("display/window/size/width")
		button_target = original_button_position.x

static func compare_floats(a, b, epsilon = 0.1):
	return abs(a - b) <= epsilon
