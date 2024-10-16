extends Area3D

@onready var game_manager = get_node("/root/World/GameManager")
@onready var rings_node = get_node("/root/World/CanvasLayer/Control/DialogueBox/RichTextLabel")
@onready var no_rings_left_box = get_node("/root/World/CanvasLayer/NoRingsLeft")
@onready var ring_ui = get_node("/root/World/RingDoorbell")
@onready var player = get_node("/root/World/Player")
@onready var control_node = get_node("/root/World/CanvasLayer/Control")
@onready var game_over_node = get_node("/root/World/GameoverRings")
@onready var doorbell_ring = $DoorbellRing
var current_npc

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("NPC"):
		ring_ui.visible = true
		current_npc = body

func _on_body_exited(body: Node3D) -> void:
	ring_ui.visible = false
	if current_npc == body:
		if current_npc.rings_left == 0:
			player.visible = false
			player.is_dialogue_active = true
			control_node.visible = false
			game_over_node.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		no_rings_left_box.visible = false
		current_npc.visible = false
		current_npc = null

func _input(event):
	if Input.is_key_pressed(KEY_F) and game_manager.is_dialogue_active() == false:
		if current_npc != null:
			doorbell_ring.play()
			current_npc.visible = true
			ring_ui.visible = false
			current_npc.rings_left -= 1
			game_manager.enter_new_dialogue(current_npc)
			rings_node.update_rings()
