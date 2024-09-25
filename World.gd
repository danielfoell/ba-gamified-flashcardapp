extends Node3D

var currentRoom

func _ready():
	GSignals.GetCurrentRoom.connect(_UpdateCurrentRoom)
	var room = StorageService.roomData
	currentRoom = room.instantiate()
	_UpdateCurrentRoom()
	%Room.add_child(currentRoom)
	if GData.user.tutorialStage == 0:
		TutorialService.StartStage(TutorialService.TUTORIALSTAGE.START)


func _UpdateCurrentRoom():
	StorageService.roomData = PackedScene.new()
	StorageService.roomData.pack(currentRoom)
	StorageService.currentRoom = currentRoom
