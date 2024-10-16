extends RichTextLabel

@onready var game_manager = get_node("/root/World/GameManager")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func update_rings ():
	text = "Doorbell Rings Left: " + str(game_manager.current_npc.rings_left)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
