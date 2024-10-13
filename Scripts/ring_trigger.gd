extends Area3D

@onready var game_manager = get_node("/root/World/GameManager")
var current_npc

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("NPC"):
		current_npc = body
		print(current_npc.foreman_name)

func _on_body_shape_exited(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if current_npc == body:
		current_npc = null

func _input(event):
	if Input.is_key_pressed(KEY_F) and game_manager.is_dialogue_active() == false:
		if current_npc != null:
			game_manager.enter_new_dialogue(current_npc)
