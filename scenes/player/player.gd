extends CharacterBody3D

@export var move_speed: float = 6.0
@export var jump_velocity: float = 5.5
@export var mouse_sensitivity: float = 0.002
@export var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var head: Node3D = $Head

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-85), deg_to_rad(85))

	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_key_pressed(KEY_SPACE) and is_on_floor():
		velocity.y = jump_velocity

	var move_input := Vector2.ZERO
	move_input.x = float(Input.is_key_pressed(KEY_D)) - float(Input.is_key_pressed(KEY_A))
	move_input.y = float(Input.is_key_pressed(KEY_S)) - float(Input.is_key_pressed(KEY_W))
	move_input = move_input.normalized()

	var direction := (transform.basis * Vector3(move_input.x, 0.0, move_input.y)).normalized()

	if direction != Vector3.ZERO:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, move_speed)
		velocity.z = move_toward(velocity.z, 0.0, move_speed)

	move_and_slide()
