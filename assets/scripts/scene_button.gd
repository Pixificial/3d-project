extends TextureButton

var _scene_path : String

func _on_TextureButton_pressed():
	get_tree().change_scene(_scene_path)
	get_tree().set_pause(false)
