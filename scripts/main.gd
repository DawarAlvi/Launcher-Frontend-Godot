extends Control

var configFilePath = "user://launcher.json"
@export var tilePrefab: PackedScene
@export var selectedTile: TextureButton
@onready var tileParent = %GridContainer

func _ready():
	if not FileAccess.file_exists(configFilePath):
		var defaultConfigFile = FileAccess.open(configFilePath, FileAccess.WRITE)
		var configAbsolutePath = defaultConfigFile.get_path_absolute()
		print(configAbsolutePath)
		defaultConfigFile.store_string(GLOBALS.getDefaultConfig(configAbsolutePath))
		defaultConfigFile.close()
	
	var configFile = FileAccess.open(configFilePath, FileAccess.READ)
	var configFileContent = configFile.get_as_text()
	
	var json = JSON.new()
	var error = json.parse(configFileContent)
	
	if error == OK:
		var data = json.data
		if typeof(data) == TYPE_ARRAY:
			var tiles = data.map(displayAppTile)
			selectTile(tiles[0])
			configFile.close()
		else:
			OS.alert("Unexpected data","Config error!")
			get_tree().quit()
	else:
		OS.alert("JSON Parse Error: " + json.get_error_message() + " in " + configFileContent + " at line " + str(json.get_error_line()) ,"Config error!")
		get_tree().quit()

func displayAppTile(appData):
	if appData.has("disable") and appData.disable == true: return
	var tile = tilePrefab.instantiate()
	if appData.has("exec"):
		tile.exec = appData.exec
	if appData.has("title"):
		tile.find_child("TitleBG").find_child("Title").text = "[center]" + appData.title
	if appData.has("image") and FileAccess.file_exists(appData.image):
		var img = Image.load_from_file(appData.image)
		if img:
			tile.find_child("Image").texture = ImageTexture.create_from_image(img)
	tileParent.add_child(tile)
	tile.selected.connect(selectTile)
	tile.deselected.connect(deselectTile)
	return tile

func selectTile(tile):
	if tile == selectedTile: return
	if selectedTile: deselectTile()
	selectedTile = tile
	selectedTile.grab_focus()
	selectedTile.find_child("AnimationPlayer").play("select")

func deselectTile(tile = selectedTile):
	tile.find_child("AnimationPlayer").play_backwards("select")
	if tile == selectedTile:
		selectedTile = null

func openConfigFile():
	OS.shell_open(ProjectSettings.globalize_path(configFilePath))

func _input(event):
	if event.is_action_pressed("exit"):
		get_tree().quit()
	if event.is_action_pressed("config"):
		openConfigFile()

func _on_close_button_pressed():
	get_tree().quit()

func _on_select_button_pressed():
	if not selectedTile: return
	selectedTile.openApp()

func _on_prev_button_pressed():
	pass

func _on_next_button_pressed():
	pass

func _on_btn_config_pressed():
	openConfigFile()
