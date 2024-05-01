extends TextureButton

signal selected
signal deselected

@export var exec: String = ""

func openApp():
	if exec != "":
		var error = OS.shell_open(exec)
		if error == OK:
			get_tree().quit()
		else:
			OS.alert("Error launching the app!\nCheck the config file for errors.")

func _on_pressed():
	openApp()

func _on_focus_entered():
	selected.emit(self)

func _on_focus_exited():
	deselected.emit(self)

func _on_mouse_entered():
	selected.emit(self)
