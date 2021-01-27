extends "res://assets/scripts/mover.gd"
#ABSTRACT, DO NOT ATTACH

func _physics_process(delta):
	_gravitate(delta)

func _gravitate(delta):
	if(self.has_method("get_is_dashing")): #If character
		if (self.call("get_is_dashing")):
			pass
		else:
			_add_to_velocity(max(0.0, (Global._gravity + _velocity.y) * delta) * Vector3.DOWN)
	else:
		_add_to_velocity(max(0.0, (Global._gravity + _velocity.y) * delta) * Vector3.DOWN)
