extends Node

signal StartSetup

enum TUTORIALSTAGE{
	START
}

func StartStage(stage):
	if stage == TUTORIALSTAGE.START:
		Dialogic.start("Start")
		#StartSetup.emit()

func SetStage(stage):
	GData.user.tutorialStage = stage

func BuildRoom():
	StorageService.currentRoom.Setup()
