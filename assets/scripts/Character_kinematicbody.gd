extends KinematicBody
#UNUSED TRASH CODE, DO NOT ATTACH
const FRICTION = 6

onready var character_camera = get_node("Character_camera")

var input_movement_right = false
var input_movement_left = false
var input_movement_forward = false
var input_movement_backward = false
var input_movement_jump = false

var movement_input_vector = Vector2()
var acceleration = 80.0
var velocity = Vector3()
var gravity = 16.0
var jump_strength = 12.0
var jump_count = 2
var last_wall_jump_timer = 0.0
var last_wall_collision_normal = Vector3()

func _ready():
	pass

func _process(delta):
	input_movement_right = Input.is_action_pressed("character_right")
	input_movement_left = Input.is_action_pressed("character_left")
	input_movement_forward = Input.is_action_pressed("character_forward")
	input_movement_backward = Input.is_action_pressed("character_backward")
	input_movement_jump = Input.is_action_just_pressed("character_jump")

	if (last_wall_jump_timer < 1.0):
		last_wall_jump_timer += delta

func _physics_process(delta):
	if (is_on_floor()):
		jump_count = 2
	#Input
	var movement_x_axis = float(input_movement_right) - float(input_movement_left)
	var movement_z_axis = float(input_movement_forward) - float(input_movement_backward)
	movement_input_vector = Vector2(movement_x_axis, movement_z_axis).normalized()
	#Horizontal Movement
	if(is_on_floor()):
		velocity += (movement_input_vector.y * (-transform.basis.z)+ movement_input_vector.x * transform.basis.x) * acceleration * delta;
	else:
		velocity += (movement_input_vector.y * (-transform.basis.z)+ movement_input_vector.x * transform.basis.x) * acceleration / 6 * delta;
	#Vertical Movement
	if (is_on_wall()):
		last_wall_jump_timer = 0.0
		last_wall_collision_normal = get_slide_collision(get_slide_count() - 1).normal
	if(input_movement_jump):
		if (last_wall_jump_timer < 0.5):
				velocity.y = 0
				velocity += (jump_strength) * (2 * last_wall_collision_normal + Vector3.UP).normalized()
				last_wall_jump_timer = 1.0
		else:
			if (jump_count > 0):
				velocity += (jump_strength - velocity.y) * Vector3.UP
				jump_count -= 1
	velocity += max(0.0, (gravity + velocity.y) * delta) * Vector3.DOWN
	#Friction
	if (Vector3(velocity.x, 0.0, velocity.z).length_squared() > 0.02):
		if(is_on_floor()):
			velocity -= FRICTION * Vector3(velocity.x, 0.0, velocity.z) * delta
		else:
			velocity -= FRICTION / 4 * Vector3(velocity.x, 0.0, velocity.z) * delta
	else:
		velocity -= Vector3(velocity.x, 0.0, velocity.z)
	velocity = move_and_slide(velocity, Vector3.UP)
