extends TextureButton

var press_scale = Vector2(0.9, 0.9)  # Scale down when pressed
var original_scale = Vector2(1, 1)  # Original size
var animation_time = 0.02  # Time for scaling effect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("pressed", Callable(self, "_on_button_pressed"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	self.scale_button(press_scale)
	await get_tree().create_timer(animation_time).timeout
	self.scale_button(original_scale) 
	get_tree().change_scene_to_file("res://Scenes/World.tscn")

func scale_button(scale: Vector2) -> void:
	self.scale = scale
