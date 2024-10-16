extends Control

@onready var pause_menu = get_node("/root/World/PauseMenu")
@onready var player_node = get_node("/root/World/Player")
@onready var dialogue_box = get_node("/root/World/CanvasLayer/Control/DialogueBox")
@onready var control_node = get_node("/root/World/CanvasLayer/Control")

func resume():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	control_node.visible = true
	player_node.is_dialogue_active = false
	pause_menu.visible = false

func pause():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	control_node.visible = false
	player_node.is_dialogue_active = true
	pause_menu.visible = true
	print(pause_menu.visible)

func _input(event):
	if Input.is_action_just_pressed("esc") and player_node.is_dialogue_active == false and dialogue_box.visible == false:
		pause()
	elif Input.is_action_just_pressed("esc") and player_node.is_dialogue_active == true and dialogue_box.visible == false:
		resume()

func _on_resume_pressed() -> void:
	resume()

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().quit()
