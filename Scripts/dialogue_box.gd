extends Panel

@onready var game_manager = get_node("/root/World/GameManager")
@onready var player_node = get_node("/root/World/Player")
@onready var score_node = get_node("/root/World/CanvasLayer/RichTextLabel")

@onready var dialogue_text : RichTextLabel = get_node("DialogueText")
@onready var talk_input : TextEdit = get_node("PlayerTextInput")
@onready var talk_button : Button = get_node("Talk")
@onready var leave_button : Button = get_node("Leave")
@onready var control_node = get_node("/root/World/CanvasLayer/Control")
@onready var win_screen = get_node("/root/World/WinningScreen")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager.on_player_talk.connect(_on_player_talk)
	game_manager.on_npc_talk.connect(_on_npc_talk)

func initialize_with_npc (npc):
		dialogue_text.text = ""
		talk_button.disabled = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		player_node.is_dialogue_active = true

func _on_talk_pressed() -> void:
	if game_manager.current_npc.password != talk_input.text:
		game_manager.dialogue_request(talk_input.text)
	elif game_manager.current_npc.password_guessed == true:
		game_manager.dialogue_request("Tell the player you have already submitted your time card and that you are ready to go to bed. Put this in your own words and stay in character.")
	elif talk_input.text == game_manager.current_npc.password:
		game_manager.timecards_submitted += 1
		score_node.update_score()
		if game_manager.timecards_submitted == 7:
			player_node.visible = false
			player_node.is_dialogue_active = true
			control_node.visible = false
			win_screen.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		score_node.update_score()
		game_manager.current_npc.password_guessed = true
		game_manager.dialogue_request("Celebrate and tell the player that you have sent your time card in and ready to get inside and away from the haunted skeletons. Stay in character.")
	else :
		game_manager.timecards_submitted += 1
		score_node.update_score()
		game_manager.current_npc.password_guessed = true
		game_manager.dialogue_request("Tell the player that you were able to log into HCSS Field successfully, and you were able to send you time card. Put this in your own words and stay in character.")


func _on_leave_pressed() -> void:
	game_manager.exit_dialogue()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	player_node.is_dialogue_active = false


func _on_player_talk ():
	talk_input.text = ""
	dialogue_text.text = "Hmm..."
	talk_button.disabled = true

func _on_npc_talk (npc_dialogue):
	dialogue_text.text = npc_dialogue
	talk_button.disabled = false
