extends Node3D

@onready var AnimPlayer = $AnimationPlayer
@onready var AnimPlayer2 = $AnimationPlayer2


func _ready():
	if GData.user.tutorialStage <= 1:
		AnimPlayer.play("RESET")
	else:
		AnimPlayer.play("Scene")
	AnimPlayer2.play("RESET")

func Unlock():
	AnimPlayer.play("Unlock")
	await AnimPlayer.animation_finished
	AnimPlayer.play("Scene")


func _On_Input_Event(camera, event, position, normal, shape_idx):
	pass # Replace with function body.


func _On_Mouse_Entered():
	AnimPlayer2.play("Pulse")


func _On_Mouse_Exited():
	AnimPlayer2.play("RESET")
