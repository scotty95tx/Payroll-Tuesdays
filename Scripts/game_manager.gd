extends Node3D

var api_key : String = "sk-JzKTgt0-oZTM5IJ7aVay5xsqgtWR1BMG-1lbu-98aAT3BlbkFJ3V3j9AAxDwPSXemJjS6FqXXO98qI8TdelaJBMB0KwA"
var url : String = "https://api.openai.com/v1/chat/completions"
var temperature : float = 0.5
var max_tokens : int = 1024
var headers = ["Content-type: application/json", "Authorization: Bearer " + api_key]
var model : String = "gpt-3.5-turbo"
var messages = []
var request : HTTPRequest

@onready var dialogue_box = get_node("/root/World/CanvasLayer/DialogueBox")
var current_npc
var timecards_submitted = 0
@export_multiline var dialogue_rules : String

signal on_player_talk
signal on_npc_talk (npc_dialogue)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	request = HTTPRequest.new()
	add_child(request)
	request.connect("request_completed", _on_request_completed)
	

func dialogue_request(player_dialogue):
	var prompt = player_dialogue
	
	if len(messages) == 0:
		var header_prompt = "Act as a " + current_npc.physical_description + " in a huanted neighborhood filled wiht foremen. "
		header_prompt += "As a character, you are " + current_npc.personality + ". "
		header_prompt += "Your location is " + current_npc.location_description + ". "
		header_prompt += "You have secret knowledge that you will not speak about unless asked by me: " + current_npc.secret_knowledge + ". "
		
		prompt = dialogue_rules + "\n" + header_prompt + "\n What do you want to say first?"
	
	messages.append({
		"role": "user",
		"content": prompt
		})
	
	on_player_talk.emit()
	
	var body = JSON.new().stringify({
		"messages": messages,
		"temperature": temperature,
		"max_tokens": max_tokens,
		"model": model
	})
	
	var send_request = request.request(url, headers, HTTPClient.METHOD_POST, body)
	
	if send_request != OK:
		print("There was an error")

func _on_request_completed (result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	print(response)
	var message = response["choices"][0]["message"]["content"]
	
	messages.append({
		"role": "system",
		"content": message
	})
	
	on_npc_talk.emit(message)

func enter_new_dialogue (npc):
	current_npc = npc
	messages = []
	dialogue_box.grab_focus()
	dialogue_box.visible = true
	dialogue_box.initialize_with_npc(npc)
	dialogue_request("")
	
func exit_dialogue ():
	current_npc = null
	messages = []
	dialogue_box.visible = false

func is_dialogue_active ():
	return dialogue_box.visible
