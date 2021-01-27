extends "res://assets/scripts/jumper.gd"
#CROUCHING / SLIDING???
const ACCEPTABLE_WALL_JUMP_INITIATION_DURATION = 0.2
const DASH_COOLDOWN = 0.8

var aim_vector = Vector3()

onready var _character_camera = get_node("CharacterCamera")

var _input_movement_right = false
var _input_movement_left = false
var _input_movement_forward = false
var _input_movement_backward = false
var _input_movement_jump = false
var _input_movement_dash = false
var _movement_input_vector = Vector2()
var _jump_count = 2
var _last_wall_jump_timer = 0.0
var _last_wall_collision_normal = Vector3()
var _is_dashing = false
var _dash_duration = 0.3
var _dash_duration_timer = 0.0
var _dash_velocity = 20.0
var _dash_cooldown_timer = 0.0
var _dash_count = 1

func _ready():
	_set_inherited_variables()

func _process(delta):
	_run_last_wall_jump_timer(delta)
	_run_dash_duration_timer(delta)
	_run_dash_cooldown_timer(delta)

func _physics_process(delta):
	_get_movement_input()
	_reset_jump_count()
	_reset_dash_count()
	#Input
	_set_movement_vector()
	#Horizontal Movement
	_move_with_movement_input(delta)
	#Vertical Movement
	_update_wall_collision()
	_jump_with_movement_input()
	_dash_with_movement_input()
	if (OS.is_debug_build()):
		if (Input.is_action_just_pressed("debug_reset_position")):
			translation = Vector3(0.0, 0.9, 0.0)

func get_is_dashing():
	return _is_dashing

func _get_movement_input():
	_input_movement_right = Input.is_action_pressed("character_right")
	_input_movement_left = Input.is_action_pressed("character_left")
	_input_movement_forward = Input.is_action_pressed("character_forward")
	_input_movement_backward = Input.is_action_pressed("character_backward")
	_input_movement_jump = Input.is_action_just_pressed("character_jump")
	_input_movement_dash = Input.is_action_just_pressed("character_dash")

func _set_inherited_variables():
	_friction = 6
	_acceleration = 80.0
	_jump_strength = 12.0

func _run_last_wall_jump_timer(delta):
	if (_last_wall_jump_timer > 0.0):
		_last_wall_jump_timer -= delta

func _reset_jump_count():
	if (is_on_floor()):
		_jump_count = 2

func _set_movement_vector():
	var movement_x_axis = float(_input_movement_right) - float(_input_movement_left)
	var movement_z_axis = float(_input_movement_forward) - float(_input_movement_backward)
	_movement_input_vector = Vector2(movement_x_axis, movement_z_axis).normalized()

func _move_with_movement_input(delta):
	#Horizontal
	if(is_on_floor()):
		_add_to_velocity((_movement_input_vector.y * (-transform.basis.z) +
		_movement_input_vector.x * transform.basis.x) * _acceleration * delta)
	else:
		_add_to_velocity((_movement_input_vector.y * (-transform.basis.z)+
		_movement_input_vector.x * transform.basis.x) * _acceleration / 6 * delta)
	#Vertical

func _update_wall_collision():
	if (is_on_wall()):
		_last_wall_jump_timer = ACCEPTABLE_WALL_JUMP_INITIATION_DURATION
		_last_wall_collision_normal = get_slide_collision(get_slide_count() - 1).normal

func _wall_jump():
	_add_to_velocity(Vector3.DOWN * _velocity.y +
	(_jump_strength) * (2 * _last_wall_collision_normal + Vector3.UP).normalized())

func _jump_with_movement_input():
	if(_input_movement_jump):
		if (_last_wall_jump_timer > 0.0 && _dash_cooldown_timer <= 0.0):
				_wall_jump()
				_last_wall_jump_timer = 0.0
		else:
			if (_jump_count > 0 && !_is_dashing):
				_jump()
				_jump_count -= 1

func _move_linearly(delta, var value):
	if (typeof(value) == TYPE_VECTOR3):
		_velocity = value
	else:
		print("Exception: Added value is not a Vector3.") #Improve this

func _run_dash_duration_timer(delta):
	if (_dash_duration_timer > 0.0):
		_dash_duration_timer -= delta
		_is_dashing = true
		_move_linearly(delta, aim_vector * _dash_velocity)
	else:
		if (_is_dashing == true):
			_velocity /= 4.0
		_is_dashing = false

func _dash():
	var correction = max(sign(-_character_camera.transform.basis.z.y), _character_camera.transform.basis.z.z)
	aim_vector = Vector3(-transform.basis.z.x + transform.basis.z.x * (1.0 - correction), -_character_camera.transform.basis.z.y, -transform.basis.z.z + transform.basis.z.z * (1.0 - correction))
	print(_character_camera.transform.basis.z.y)
	print(_character_camera.transform.basis.z.z)
	if (aim_vector.y > 0.0):
		aim_vector.y = 0.0
	_velocity = Vector3()
	_dash_duration_timer = _dash_duration
	_dash_cooldown_timer = DASH_COOLDOWN
	_dash_count -= 1

func _run_dash_cooldown_timer(delta):
	if (_dash_cooldown_timer > 0.0):
		_dash_cooldown_timer -= delta

func _dash_with_movement_input():
	if(_input_movement_dash && _dash_cooldown_timer <= 0.0 && _dash_count > 0):
		_dash()

func _reset_dash_count():
	if (is_on_floor() || is_on_wall()):
		_dash_count = 1
