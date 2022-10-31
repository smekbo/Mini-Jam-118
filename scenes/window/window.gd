extends Node2D

signal shutter_open
signal shutter_closed

func open():
	$AnimationPlayer.play("open_shutter")
	pass

func close():
	$AnimationPlayer.play("close_shutter")
	pass

func shutter_opened():
	emit_signal("shutter_open")

func shutter_closed():
	emit_signal("shutter_closed")


func _on_restart_pressed():
	get_tree().change_scene("res://main.tscn")
	pass # Replace with function body.

func _on_title_pressed():
	get_tree().change_scene("res://title.tscn")
	pass # Replace with function body.
