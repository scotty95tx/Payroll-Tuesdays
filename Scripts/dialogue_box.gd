extends Panel

@onready var game_manager = get_node("/root/World/GameManager")
@onready var player_node = get_node("/root/World/Player")
@onready var score_node = get_node("/root/World/CanvasLayer/RichTextLabel")

@onready var dialogue_text : RichTextLabel = get_node("DialogueText")
@onready var talk_input : TextEdit = get_node("PlayerTextInput")
@onready var talk_button : Button = get_node("Talk")
@onready var leave_button : Button = get_node("Leave")

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
