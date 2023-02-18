class_name PlanetCharacter extends CharacterBody3D

@export var planet: Node3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var move_vel : Vector3
var up_vel: Vector3

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	$mesh.global_transform.basis = $camera_yaw.global_transform.basis

func _physics_process(delta: float) -> void:
	up_direction = (global_position - planet.global_position).normalized()
	transform.basis = Basis.looking_at(up_direction.cross(basis.x), up_direction)
	
	if !is_on_floor():
		up_vel += -up_direction * gravity * delta * 3.0
	else: up_vel = Vector3.ZERO
	
	if Input.is_action_just_pressed("jump") && is_on_floor():
		up_vel += up_direction * JUMP_VELOCITY * 3.0
	
	var input_dir := Input.get_vector("mv_l", "mv_r", "mv_fwd", "mv_b")
	var direction = ($camera_yaw.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		move_vel = direction * SPEED
	else:
		move_vel = Vector3.ZERO
	
	velocity = move_vel + up_vel
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		$camera_yaw.rotate_y(event.relative.x* -0.001)
		$camera_yaw/camera_pitch.rotate_x(event.relative.y * -0.001)
