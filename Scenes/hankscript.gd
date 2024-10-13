extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export_multiline var physical_description : String
@export_multiline var location_description : String
@export_multiline var personality : String
@export_multiline var secret_knowledge : String
@export var password : String = "hotdogs"
@export var foreman_name : String = "Hank"
var password_guessed : bool = false
