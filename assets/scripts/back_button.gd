extends TextureButton

onready var options_menu_container = get_owner()

func _on_BackButton_pressed():
	if (options_menu_container.options_menu_type == options_menu_container.OptionsMenuType.TYPE_SCENE):
		get_tree().change_scene("res://assets/scenes/metas/main_menu.tscn")
	else:
		options_menu_container.emit_signal("pause_menu_requested")
