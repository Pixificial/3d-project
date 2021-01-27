extends KinematicBody
#ABSTRACT, DO NOT ATTACH

var _acceleration
var _velocity = Vector3()
var _friction = 0.0

func _physics_process(delta):
	_rub(delta)
	_velocity = move_and_slide(_velocity, Vector3.UP)

func _set_velocity(var value):
	if (typeof(value) == TYPE_VECTOR3):
		_velocity = value
	else:
		print("Exception: Set value is not a Vector3.") #Improve this

func _add_to_velocity(var value):
	if (typeof(value) == TYPE_VECTOR3):
		_velocity += value
	else:
		print("Exception: Added value is not a Vector3.") #Improve this

func _rub(delta):
	if (Vector3(_velocity.x, 0.0, _velocity.z).length_squared() > 0.02):
		if(is_on_floor()):
			_velocity -= _friction * Vector3(_velocity.x, 0.0, _velocity.z) * delta
		else:
			_velocity -= _friction / 4 * Vector3(_velocity.x, 0.0, _velocity.z) * delta
	else:
		_velocity -= Vector3(_velocity.x, 0.0, _velocity.z)
