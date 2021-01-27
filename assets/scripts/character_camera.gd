extends Camera
#MUST BE ATTACHED TO A CAMERA NODE WITH PLAYER PARENT
onready var character_kinematicbody = get_parent()
var sensitivity : Vector2
var mouse_relative : Vector2

func _ready():
	fov = Settings.fov
	sensitivity = Settings.sensitivity
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Settings.connect("settings_changed", self, "_on_Settings_settings_changed")


func _input(event):
	if event is InputEventMouseMotion:
		mouse_relative = event.relative

func _process(delta):
	character_kinematicbody.rotate(Vector3.DOWN, sensitivity.x * mouse_relative.x / 600.0)
	rotate(Vector3.LEFT, sensitivity.y * mouse_relative.y / 600.0)
	set_rotation(Vector3(clamp(rotation.x, -PI / 2, PI / 2), rotation.y, rotation.z))
	mouse_relative = Vector2()

func _on_Settings_settings_changed():
	fov = Settings.fov
	sensitivity = Settings.sensitivity
