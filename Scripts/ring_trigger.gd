extends Area3D

@onready var game_manager = get_node("/root/World/GameManager")
@onready var rings_node = get_node("/root/World/CanvasLayer/Control/DialogueBox/RichTextLabel")
@onready var no_rings_left_box = get_node("/root/World/CanvasLayer/NoRingsLeft")
var current_npc

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("NPC"):
		current_npc = body
		print(current_npc.foreman_name)

func _on_body_exited(body: Node3D) -> void:
	if current_npc == body:
		if current_npc.rings_left == 0:
			print("you lose")
		no_rings_left_box.visible = false
		current_npc = null

func _input(event):
	if Input.is_key_pressed(KEY_F) and game_manager.is_dialogue_active() == false:
		if current_npc != null:
			current_npc.rings_left -= 1
			game_manager.enter_new_dialogue(current_npc)
			rings_node.update_rings()
