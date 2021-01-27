extends VBoxContainer

signal pause_menu_requested()

enum OptionsMenuType {TYPE_SCENE, TYPE_SUBSCENE}

onready var full_screen_button = get_node("SettingsContainer/VideoSettingsContainer/FullScreenContainer/FullScreenButton")
onready var borderless_button = get_node("SettingsContainer/VideoSettingsContainer/BorderlessContainer/BorderlessButton")
onready var vsync_button = get_node("SettingsContainer/VideoSettingsContainer/VSYNCContainer/VSYNCButton")
onready var resolution_line = get_node("SettingsContainer/VideoSettingsContainer/ResolutionContainer/ResolutionLine")
onready var fov_slider = get_node("SettingsContainer/VideoSettingsContainer/FOVContainer/FOVSlider")
onready var anti_aliasing_slider = get_node("SettingsContainer/VideoSettingsContainer/AntiAliasingContainer/AntiAliasingSlider")

onready var forward_button = get_node("SettingsContainer/ControlsSettingsContainer/ForwardContainer/ForwardButton")
onready var forward_text = get_node("SettingsContainer/ControlsSettingsContainer/ForwardContainer/ForwardText")
onready var backward_button = get_node("SettingsContainer/ControlsSettingsContainer/BackwardContainer/BackwardButton")
onready var backward_text = get_node("SettingsContainer/ControlsSettingsContainer/BackwardContainer/BackwardText")
onready var left_button = get_node("SettingsContainer/ControlsSettingsContainer/LeftContainer/LeftButton")
onready var left_text = get_node("SettingsContainer/ControlsSettingsContainer/LeftContainer/LeftText")
onready var right_button = get_node("SettingsContainer/ControlsSettingsContainer/RightContainer/RightButton")
onready var right_text = get_node("SettingsContainer/ControlsSettingsContainer/RightContainer/RightText")
onready var jump_button = get_node("SettingsContainer/ControlsSettingsContainer/JumpContainer/JumpButton")
onready var jump_text = get_node("SettingsContainer/ControlsSettingsContainer/JumpContainer/JumpText")
onready var dash_button = get_node("SettingsContainer/ControlsSettingsContainer/DashContainer/DashButton")
onready var dash_text = get_node("SettingsContainer/ControlsSettingsContainer/DashContainer/DashText")
onready var sensitivity_x_slider = get_node("SettingsContainer/ControlsSettingsContainer/SensitivityXContainer/SensitivityXSlider")
onready var sensitivity_y_slider = get_node("SettingsContainer/ControlsSettingsContainer/SensitivityYContainer/SensitivityYSlider")

onready var master_volume_slider = get_node("SettingsContainer/AudioSettingsContainer/MasterVolumeContainer/MasterVolumeSlider")
onready var music_volume_slider = get_node("SettingsContainer/AudioSettingsContainer/MusicVolumeContainer/MusicVolumeSlider")
onready var sfx_volume_slider = get_node("SettingsContainer/AudioSettingsContainer/SFXVolumeContainer/SFXVolumeSlider")

var _control_changable = true
export(OptionsMenuType) var options_menu_type = OptionsMenuType.TYPE_SCENE

var unapplied_forward_input = Settings.config_file.get_value("controls", "character_forward")
var unapplied_backward_input = Settings.config_file.get_value("controls", "character_backward")
var unapplied_left_input = Settings.config_file.get_value("controls", "character_left")
var unapplied_right_input = Settings.config_file.get_value("controls", "character_right")
var unapplied_jump_input = Settings.config_file.get_value("controls", "character_jump")
var unapplied_dash_input = Settings.config_file.get_value("controls", "character_dash")

func _ready():
	update_options_menu()

func get_readable_string(event):
	if (event is InputEventKey):
		return OS.get_scancode_string(event.get_scancode())
	elif (event is InputEventMouseButton):
		return "Mouse " + str(event.get_button_index())
	else:
		return event.as_text()

func update_options_menu():
	full_screen_button.set_pressed(Settings.config_file.get_value("video", "full_screen"))
	borderless_button.set_pressed(Settings.config_file.get_value("video", "borderless"))
	borderless_button.set_disabled(full_screen_button.is_pressed())
	vsync_button.set_pressed(Settings.config_file.get_value("video", "vsync"))
	resolution_line.set_text(str(Settings.config_file.get_value("video", "resolution").x)+ "x" + str(Settings.config_file.get_value("video", "resolution").y))
	fov_slider.set_value(Settings.fov)
	anti_aliasing_slider.set_value(Settings.config_file.get_value("video", "msaa"))
	
	forward_text.set_text("|" + get_readable_string(unapplied_forward_input))
	backward_text.set_text("|" + get_readable_string(unapplied_backward_input))
	left_text.set_text("|" + get_readable_string(unapplied_left_input))
	right_text.set_text("|" + get_readable_string(unapplied_right_input))
	jump_text.set_text("|" + get_readable_string(unapplied_jump_input))
	dash_text.set_text("|" + get_readable_string(unapplied_dash_input))
	sensitivity_x_slider.set_value(Settings.sensitivity.x)
	sensitivity_y_slider.set_value(Settings.sensitivity.y)
	
	master_volume_slider.set_value(Settings.config_file.get_value("audio", "master_volume"))
	music_volume_slider.set_value(Settings.config_file.get_value("audio", "music_volume"))
	sfx_volume_slider.set_value(Settings.config_file.get_value("audio", "sfx_volume"))

func _parse_resolution_string(var string : String):
	var x_char_position = string.find("x")
	if (x_char_position == -1):
		print("x char not found!")
		return OS.window_size
	else:
		var assigned_width = float(string.left(x_char_position))
		var assigned_height = float(string.right(x_char_position + 1))
		if (assigned_width == 0 || assigned_height == 0):
			assigned_width = Settings.get_default_settings()["video"]["resolution"].x
			assigned_height = Settings.get_default_settings()["video"]["resolution"].y
		else:
			assigned_width = max(assigned_width, 1024)
			assigned_height = max(assigned_height, 600)
		return Vector2(assigned_width, assigned_height)

func _on_ApplyButton_pressed():
	Settings.config_file.set_value("video", "full_screen", full_screen_button.is_pressed())
	Settings.config_file.set_value("video", "borderless", borderless_button.is_pressed())
	borderless_button.set_disabled(full_screen_button.is_pressed())
	Settings.config_file.set_value("video", "vsync", vsync_button.is_pressed())
	Settings.config_file.set_value("video", "resolution", _parse_resolution_string(resolution_line.text))
	Settings.config_file.set_value("video", "fov", fov_slider.get_value())
	Settings.config_file.set_value("video", "msaa", anti_aliasing_slider.get_value())
	
	Settings.config_file.set_value("controls", "character_forward", unapplied_forward_input)
	Settings.config_file.set_value("controls", "character_backward", unapplied_backward_input)
	Settings.config_file.set_value("controls", "character_left", unapplied_left_input)
	Settings.config_file.set_value("controls", "character_right", unapplied_right_input)
	Settings.config_file.set_value("controls", "character_jump", unapplied_jump_input)
	Settings.config_file.set_value("controls", "character_dash", unapplied_dash_input)
	Settings.config_file.set_value("controls", "sensitivity", Vector2(sensitivity_x_slider.get_value(), sensitivity_y_slider.get_value()))
	
	Settings.config_file.set_value("audio", "master_volume", master_volume_slider.get_value())
	Settings.config_file.set_value("audio", "music_volume", music_volume_slider.get_value())
	Settings.config_file.set_value("audio", "sfx_volume", sfx_volume_slider.get_value())
	Settings.apply_settings()
	Settings.emit_signal("settings_changed")
	resolution_line.set_text(str(OS.window_size.x)+ "x" + str(OS.window_size.y))
	Settings.save_settings()

func _on_any_setting_interacted(interaction):
	if (interaction is InputEventMouseButton):
		_control_changable = false
		forward_button.set_pressed(false)
		backward_button.set_pressed(false)
		left_button.set_pressed(false)
		right_button.set_pressed(false)
		jump_button.set_pressed(false)
		dash_button.set_pressed(false)

func _on_ForwardButton_button_down():
	backward_button.set_pressed(false)
	left_button.set_pressed(false)
	right_button.set_pressed(false)
	jump_button.set_pressed(false)
	dash_button.set_pressed(false)

func _on_BackwardButton_button_down():
	forward_button.set_pressed(false)
	left_button.set_pressed(false)
	right_button.set_pressed(false)
	jump_button.set_pressed(false)
	dash_button.set_pressed(false)

func _on_LeftButton_button_down():
	forward_button.set_pressed(false)
	backward_button.set_pressed(false)
	right_button.set_pressed(false)
	jump_button.set_pressed(false)
	dash_button.set_pressed(false)

func _on_RightButton_button_down():
	forward_button.set_pressed(false)
	backward_button.set_pressed(false)
	left_button.set_pressed(false)
	jump_button.set_pressed(false)
	dash_button.set_pressed(false)

func _on_JumpButton_button_down():
	forward_button.set_pressed(false)
	backward_button.set_pressed(false)
	left_button.set_pressed(false)
	right_button.set_pressed(false)
	dash_button.set_pressed(false)

func _on_DashButton_button_down():
	forward_button.set_pressed(false)
	backward_button.set_pressed(false)
	left_button.set_pressed(false)
	right_button.set_pressed(false)
	jump_button.set_pressed(false)

func _input(event):
	
	if (event is InputEventMouseButton):
		if (event.pressed == false):
			if (_control_changable):
				if (forward_button.is_pressed()):
					unapplied_forward_input = event
					forward_text.set_text("|Mouse " + str(event.get_button_index()))
					forward_button.set_pressed(false)
				if (backward_button.is_pressed()):
					unapplied_backward_input = event
					backward_text.set_text("|Mouse " + str(event.get_button_index()))
					backward_button.set_pressed(false)
				if (left_button.is_pressed()):
					unapplied_left_input = event
					left_text.set_text("|Mouse " + str(event.get_button_index()))
					left_button.set_pressed(false)
				if (right_button.is_pressed()):
					unapplied_right_input = event
					right_text.set_text("|Mouse " + str(event.get_button_index()))
					right_button.set_pressed(false)
				if (jump_button.is_pressed()):
					unapplied_jump_input = event
					jump_text.set_text("|Mouse " + str(event.get_button_index()))
					jump_button.set_pressed(false)
				if (dash_button.is_pressed()):
					unapplied_dash_input = event
					dash_text.set_text("|Mouse " + str(event.get_button_index()))
					dash_button.set_pressed(false)
			else:
				_control_changable = true
	if (event is InputEventKey):
		if (event.pressed == false):
			if (_control_changable):
				if (forward_button.is_pressed()):
					unapplied_forward_input = event
					forward_text.set_text("|" + get_readable_string(unapplied_forward_input))
					forward_button.set_pressed(false)
				if (backward_button.is_pressed()):
					unapplied_backward_input = event
					backward_text.set_text("|" + get_readable_string(unapplied_backward_input))
					backward_button.set_pressed(false)
				if (left_button.is_pressed()):
					unapplied_left_input = event
					left_text.set_text("|" + get_readable_string(unapplied_left_input))
					left_button.set_pressed(false)
				if (right_button.is_pressed()):
					unapplied_right_input = event
					right_text.set_text("|" + get_readable_string(unapplied_right_input))
					right_button.set_pressed(false)
				if (jump_button.is_pressed()):
					unapplied_jump_input = event
					jump_text.set_text("|" + get_readable_string(unapplied_jump_input))
					jump_button.set_pressed(false)
				if (dash_button.is_pressed()):
					unapplied_dash_input = event
					dash_text.set_text("|" + get_readable_string(unapplied_dash_input))
					dash_button.set_pressed(false)
			else:
				_control_changable = true
