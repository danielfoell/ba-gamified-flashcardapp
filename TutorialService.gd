extends Node

signal StartSetup

enum TUTORIALSTAGE{
	START = 0,
	FIRSTLEVELUP = 1
}

func _ready():
	Dialogic.signal_event.connect(_On_Dialogic_Signal)

func _process(_delta):
	pass

func StartStage(stage):
	if stage == TUTORIALSTAGE.START:
		get_tree().get_root().get_node("World").get_node("UI").hide()
		Dialogic.start("Start")
	elif stage == TUTORIALSTAGE.FIRSTLEVELUP:
		SetStage(TUTORIALSTAGE.FIRSTLEVELUP)
		if get_tree().get_root().has_node("Main"): 
			var FcInterface = get_tree().get_root().get_node("Main")
			FcInterface.add_user_signal("closed")
			await Signal(FcInterface, "closed")
		Dialogic.start("FirstLevelup")

func SetStage(stage):
	GData.user.tutorialStage = stage

func _On_Dialogic_Signal(argument: String):
	if argument == "ST1_BuildRoom":
		StorageService.currentRoom.get_node("Background").no_depth_test = false
		StorageService.currentRoom.get_node("AnimationPlayer").play("FIRSTBUILDUP")
		await StorageService.currentRoom.get_node("AnimationPlayer").animation_finished
		StorageService.currentRoom.get_node("Flashcards").animation_player.play("Pulse")
		var UI = get_tree().get_root().get_node("World").get_node("UI")
		var UI2 = UI.get_node("MarginContainer")
		UI2.modulate.a = 0
		UI.show()
		var tween = get_tree().create_tween()
		tween.tween_property(UI2, "modulate:a", 1, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		StorageService.SaveRoom()
	elif argument == "ST2_UNLOCKPC":
		var room = StorageService.currentRoom
		room.get_node("Computer").Unlock()
		await room.get_node("Computer").AnimPlayer.animation_finished
		room.get_node("Rob").Unlock()
		StorageService.SaveRoom()
		GData.user.tutorialStage = 2
		StorageService.SaveUser()
