extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export_multiline var physical_description : String
@export_multiline var location_description : String
@export_multiline var personality : String
@export_multiline var secret_knowledge : String
@export var password : String = "cheese"
@export var foreman_name : String = "Bolt-Master Bob"
var password_guessed : bool = false
var rings_left = 3
