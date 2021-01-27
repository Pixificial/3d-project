extends Node
#IMPROVE THIS

signal settings_changed()

const CONFIG_PATH = "res://user/settings.cfg"

var config_file = ConfigFile.new()
var load_error = config_file.load(CONFIG_PATH)

var fov
var sensitivity : Vector2

var _default_settings = {
	"video": {"full_screen": false, "borderless": false, "vsync": true, "resolution": OS.get_screen_size(), "fov": 90.0, "msaa": Viewport.MSAA_DISABLED},
	"controls": {"character_forward": InputMap.get_action_list("character_forward")[0], "character_backward": InputMap.get_action_list("character_backward")[0],
		"character_left": InputMap.get_action_list("character_left")[0], "character_right": InputMap.get_action_list("character_right")[0],
		"character_jump": InputMap.get_action_list("character_jump")[0], "character_dash": InputMap.get_action_list("character_dash")[0],
		"sensitivity": Vector2(1.0, 1.0)},
	"audio": {"master_volume": 100.0, "music_volume": 100.0, "sfx_volume": 100.0}
}

func _ready():
	if (load_error == OK):
		print("Existing settings successfully loaded.")
	else:
		if (load_error == ERR_FILE_NOT_FOUND):
			print("No settings file found. Creating a default file.")
			set_to_default()
			save_settings()
		else:
			print("Something went wrong with loading! Error code: " + str(load_error))
	apply_settings()
	#Audio settings are used in AudioPlayer nodes

func set_to_default():
	config_file.set_value("video", "full_screen", _default_settings["video"]["full_screen"])
	config_file.set_value("video", "borderless", _default_settings["video"]["borderless"])
	config_file.set_value("video", "vsync", _default_settings["video"]["vsync"])
	config_file.set_value("video", "resolution", _default_settings["video"]["resolution"])
	config_file.set_value("video", "fov", _default_settings["video"]["fov"])
	config_file.set_value("video", "msaa", _default_settings["video"]["msaa"])
	
	config_file.set_value("controls", "character_forward", _default_settings["controls"]["character_forward"])
	config_file.set_value("controls", "character_backward", _default_settings["controls"]["character_backward"])
	config_file.set_value("controls", "character_left", _default_settings["controls"]["character_left"])
	config_file.set_value("controls", "character_right", _default_settings["controls"]["character_right"])
	config_file.set_value("controls", "character_jump", _default_settings["controls"]["character_jump"])
	config_file.set_value("controls", "character_dash", _default_settings["controls"]["character_dash"])
	config_file.set_value("controls", "sensitivity", _default_settings["controls"]["sensitivity"])
	
	config_file.set_value("audio", "master_volume", _default_settings["audio"]["master_volume"])
	config_file.set_value("audio", "music_volume", _default_settings["audio"]["music_volume"])
	config_file.set_value("audio", "sfx_volume", _default_settings["audio"]["sfx_volume"])

func save_settings():
	var save_error = config_file.save(CONFIG_PATH)
	if (save_error == OK):
		print("Default file successfully saved.")
	else:
		print("Something went wrong with saving! Error code: " + str(save_error))

func apply_settings():
	OS.set_window_fullscreen(config_file.get_value("video", "full_screen", _default_settings["video"]["full_screen"]))
	OS.set_borderless_window(config_file.get_value("video", "borderless", _default_settings["video"]["borderless"]))
	OS.set_use_vsync(config_file.get_value("video", "vsync", _default_settings["video"]["vsync"]))
	OS.set_window_size(config_file.get_value("video", "resolution", _default_settings["video"]["resolution"]))
	fov = config_file.get_value("video", "fov", _default_settings["video"]["fov"])
	get_viewport().set_msaa(config_file.get_value("video", "msaa", _default_settings["video"]["msaa"]))
	
	InputMap.action_erase_event("character_forward", InputMap.get_action_list("character_forward")[InputMap.get_action_list("character_forward").size() - 1])
	InputMap.action_add_event("character_forward", config_file.get_value("controls", "character_forward"))
	InputMap.action_erase_event("character_backward", InputMap.get_action_list("character_backward")[InputMap.get_action_list("character_backward").size() - 1])
	InputMap.action_add_event("character_backward", config_file.get_value("controls", "character_backward"))
	InputMap.action_erase_event("character_left", InputMap.get_action_list("character_left")[InputMap.get_action_list("character_left").size() - 1])
	InputMap.action_add_event("character_left", config_file.get_value("controls", "character_left"))
	InputMap.action_erase_event("character_right", InputMap.get_action_list("character_right")[InputMap.get_action_list("character_right").size() - 1])
	InputMap.action_add_event("character_right", config_file.get_value("controls", "character_right"))
	InputMap.action_erase_event("character_jump", InputMap.get_action_list("character_jump")[InputMap.get_action_list("character_jump").size() - 1])
	InputMap.action_add_event("character_jump", config_file.get_value("controls", "character_jump"))
	InputMap.action_erase_event("character_dash", InputMap.get_action_list("character_dash")[InputMap.get_action_list("character_dash").size() - 1])
	InputMap.action_add_event("character_dash", config_file.get_value("controls", "character_dash"))
	sensitivity = config_file.get_value("controls", "sensitivity", _default_settings["controls"]["sensitivity"])
#	InputMap.get_action_list("character_forward")[0] = config_file.get_value("controls", "character_forward", _default_settings["controls"]["character_forward"])
#	InputMap.get_action_list("character_backward")[0] = config_file.get_value("controls", "character_backward", _default_settings["controls"]["character_backward"])
#	InputMap.get_action_list("character_left")[0] = config_file.get_value("controls", "character_left", _default_settings["controls"]["character_left"])
#	InputMap.get_action_list("character_right")[0] = config_file.get_value("controls", "character_right", _default_settings["controls"]["character_right"])
#	InputMap.get_action_list("character_jump")[0] = config_file.get_value("controls", "character_jump", _default_settings["controls"]["character_jump"])
#	InputMap.get_action_list("character_dash")[0] = config_file.get_value("controls", "character_dash", _default_settings["controls"]["character_dash"])

func get_default_settings():
	return _default_settings
