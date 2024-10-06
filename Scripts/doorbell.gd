extends Area3D

var is_near_doorbell = false 

func ring_doorbell():
	print("doorbell rang")

func _ready() -> void:
	var doorbell_label = get_node("CanvasLayer/DoorbellLabel")
	if doorbell_label == null:
		print("not found doorbell")
	else:
		print("Dorbell has been found")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ring_doorbell"):
		if is_near_doorbell:
			ring_doorbell()


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		is_near_doorbell = true
		print("Player is near the doorbell")

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		is_near_doorbell = false
		print("Player has exited the doorbell area")
