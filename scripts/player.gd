extends CharacterBody3D

@export_group("Camera")
@export_range(0.0,1.0) var mouse_sensitivity = 0.25

@export_group("Movement")
@export var move_speed := 8.0
@export var acceleration := 30.0
@export var rotation_speed := 10.0

@onready var _camera_pivot: Node3D = %CameraPivot
@onready var _camera: Node3D = %Camera
@onready var _character: Node3D = %Character


var _camera_input_direction := Vector2.ZERO
var _last_movement_direction := Vector3.BACK

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion &&
		Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
	)
	
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * mouse_sensitivity
		

func _physics_process(delta: float) -> void:
	# CAMERA ROTATION
	_camera_pivot.rotation.x += _camera_input_direction.y * delta
	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, PI/16, PI/3)
	_camera_pivot.rotation.y -= _camera_input_direction.x * delta
	_camera_input_direction = Vector2.ZERO
	
	# MOVEMENT INPUT
	
	var raw_direction := Input.get_vector("move_left","move_right", "move_forward", "move_back")
	var forward := _camera.global_basis.z
	var right := _camera.global_basis.x
	
	var move_direction := forward * raw_direction.y + right * raw_direction.x
	move_direction.y = 0
	move_direction = move_direction.normalized()
	
	velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)
	move_and_slide()
	
	if move_direction.length() > 0.2:
		_last_movement_direction = move_direction

	var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	_character.global_rotation.y = lerp_angle(_character.rotation.y, target_angle, rotation_speed * delta)
