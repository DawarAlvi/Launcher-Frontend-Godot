extends Node

func getDefaultConfig(configFilePath):
	return """[
	{
		"title": "Example App",
		"exec": """ + '"' + configFilePath + '"' + """,
		"image": "C:/path/to/image.jpg",
		"disable":false
	}
]"""
