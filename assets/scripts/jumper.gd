extends "res://assets/scripts/walker.gd"
#ABSTRACT, DO NOT ATTACH
var _jump_strength = 0.0

func _jump():
	_add_to_velocity((_jump_strength - _velocity.y) * Vector3.UP)
