extends CharacterBody3D

@onready var camera_mount: Node3D = $camera_mount
@onready var animation_player: AnimationPlayer = $Visuals/Barbarian/AnimationPlayer
@onready var is_dialogue_active = false
@onready var blaster_anim = $Visuals/Barbarian/Rig/Skeleton3D/Blaster/AnimationPlayer
@onready var blaster_barrel = $Visuals/Barbarian/Rig/Skeleton3D/Blaster/RayCast3D
@onready var health_bar = $"../CanvasLayer/Health/HealthBar"
@onready var game_over_node = get_node("/root/World/Gameover")
@onready var game_over_node_rings = get_node("/root/World/GameoverRings")
@onready var player = $"."
@onready var control_node = get_node("/root/World/CanvasLayer/Control")
@onready var blast = $Blast

const SPEED = 1.2
const HIT_STAGGER = 8.0
var hp = 20.0

var ray = load("res://Scenes/ray.tscn")
var instance

@export var JUMP_VELOCITY = 0

@export var sens_horizontal = 0.5
@export var sens_vertical = 0.5

signal player_hit

func _ready():
	health_bar.value = hp
	add_to_group("Player")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if event is InputEventMouseMotion and is_dialogue_active == false:
		rotate_y(deg_to_rad(-event.relative.x*sens_horizontal))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y*sens_vertical))


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_dialogue_active == false:
		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			if animation_player.current_animation != 'Running_A':
				animation_player.play('Running_A')
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			if animation_player.current_animation != 'Idle':
				animation_player.play('Idle')
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		move_and_slide()
		
		if Input.is_action_pressed("blast"):
			if !blaster_anim.is_playing():
				blaster_anim.play("blast")
				instance = ray.instantiate()
				instance.position = blaster_barrel.global_position
				instance.transform.basis = blaster_barrel.global_transform.basis
				get_parent().add_child(instance)
	else:
		animation_player.current_animation = "Idle"

func hit(dir):
	hp -= 1
	health_bar.value = hp
	if hp == 0 and game_over_node_rings.visible == false:
		player.visible = false
		player.is_dialogue_active = true
		control_node.visible = false
		game_over_node.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	emit_signal("player_hit")
