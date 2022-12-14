extends Node

export(Array, PackedScene) var levelScenes : Array

var currentLevelIndex:int = 0

#func _ready():
#	change_level(currentLevelIndex)

func change_level(levelIndex:int):
	currentLevelIndex = levelIndex
	if levelIndex >= levelScenes.size() :
		currentLevelIndex = 0
	
	get_tree().change_scene( (levelScenes[currentLevelIndex] as PackedScene).resource_path )

func increment_level():
	change_level(currentLevelIndex + 1)
