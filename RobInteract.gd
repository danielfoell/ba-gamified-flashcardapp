extends Node3D

@onready var AnimPlayer = $AnimationPlayer
@onready var AnimPlayer2 = $AnimationPlayer2
@onready var audio_stream_player = $AudioStreamPlayer

const FAQ = preload("res://FAQ.tscn")

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
	if(GData.canInteract):
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
				get_tree().get_root().add_child(FAQ.instantiate())


func _On_Mouse_Entered():
	if(GData.canInteract):
		audio_stream_player.play()
		AnimPlayer2.play("Pulse")


func _On_Mouse_Exited():
	if(GData.canInteract):
		AnimPlayer2.play("RESET")
