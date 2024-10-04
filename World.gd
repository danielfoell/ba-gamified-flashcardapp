extends Node3D

var currentRoom

func _ready():
	GSignals.GetCurrentRoom.connect(_UpdateCurrentRoom)
	var room = StorageService.roomData
	currentRoom = room.instantiate()
	_UpdateCurrentRoom()
	%Room.add_child(currentRoom)
	if GData.user.tutorialStage == TutorialService.TUTORIALSTAGE.START:
		TutorialService.StartStage(TutorialService.TUTORIALSTAGE.START)
	var currentTime = Time.get_datetime_dict_from_system()
	var hours = (24 - currentTime["hour"]) * 3600
	var minutes = (60 - currentTime["minute"]) * 60
	var seconds = 60 - currentTime["second"]
	var time = hours + minutes + seconds
	var timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.start(time)
	timer.timeout.connect(_On_Timer_Timeout)

func _UpdateCurrentRoom():
	StorageService.roomData = PackedScene.new()
	StorageService.roomData.pack(currentRoom)
	StorageService.currentRoom = currentRoom

func _On_Timer_Timeout():
	GData.user.addedDailyStreak = false
