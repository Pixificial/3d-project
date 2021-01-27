extends CanvasLayer

onready var _back_texture_rect = get_node("BackTextureRect")
onready var _pause_panel = get_node("PausePanel")
onready var _options_menu_container = get_node("OptionsMenuContainer")

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func _input(event):
	if (event.is_action_pressed("ui_cancel")):
		_toggle_pause_menu()

func _toggle_pause_menu():
	get_tree().set_pause(!get_tree().is_paused())
	if (get_tree().is_paused()):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if (_back_texture_rect.has_method("set_visible")):
		_back_texture_rect.set_visible(get_tree().is_paused())
	if (_pause_panel.has_method("set_visible")):
		_pause_panel.set_visible(get_tree().is_paused())
	if (_options_menu_container.has_method("set_visible")):
		_options_menu_container.set_visible(false)

func _toggle_between_pause_menu_and_options_menu():
	if (_pause_panel.has_method("set_visible")):
		_pause_panel.set_visible(!_pause_panel.is_visible())
	if (_options_menu_container.has_method("set_visible")):
		_options_menu_container.update_options_menu()
		_options_menu_container.set_visible(!_options_menu_container.is_visible())

func _on_ContinueTextureButton_pressed():
	_toggle_pause_menu()

func _on_OptionsTextureButton_pressed():
	_toggle_between_pause_menu_and_options_menu()

func _on_OptionsMenuContainer_pause_menu_requested():
	_toggle_between_pause_menu_and_options_menu()
