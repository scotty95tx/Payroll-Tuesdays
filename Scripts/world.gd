extends Node3D

@onready var hit_rect = $PlayerHitUI/ColorRect
@onready var spawns = $Neighborhood/Spawns
@onready var navigation_region = $Neighborhood/NavigationRegion3D
@onready var pause_menu = get_node("/root/World/PauseMenu")

var skeleton = load("res://Scenes/groupskeletons.tscn")
var instance 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_player_player_hit() -> void:
	hit_rect.visible = true
	await get_tree().create_timer(0.2).timeout
	hit_rect.visible = false

func _get_random_child(parent_node):
	var random_id = randi() % parent_node.get_child_count()
	return parent_node.get_child(random_id)

func _on_skeleton_spawn_timer_timeout() -> void:
	var spawn_point = _get_random_child(spawns).global_position
	instance = skeleton.instantiate()
	instance.position = spawn_point
	navigation_region.add_child(instance)

#func _input(event):
	#if Input.is_action_just_pressed("esc") and get_tree().paused == false:
		#pause_menu.pause()
