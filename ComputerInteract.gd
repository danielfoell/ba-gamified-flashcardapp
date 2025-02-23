extends Node3D

@onready var AnimPlayer = $AnimationPlayer
const ComputerScreen = preload("res://ComputerScreen.tscn")
@onready var audio_stream_player = $AudioStreamPlayer

func _ready():
	AnimPlayer.play("RESET")

func Unlock():
	AnimPlayer.play("Unlock")
#
#func _on_input_event(camera, event, position, normal, shape_idx):
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			#if StorageService.decks.is_empty():
				#get_tree().get_root().add_child(NEWDECK.instantiate())
			#else:
				#get_tree().get_root().add_child(MAIN.instantiate())

func _On_Monitor_Input_Event(camera, event, position, normal, shape_idx):
	if(GData.canInteract):
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
				if StorageService.decks.is_empty():
					get_tree().get_root().add_child(ComputerScreen.instantiate())
				else:
					get_tree().get_root().add_child(ComputerScreen.instantiate())

func _On_Monitor_Mouse_Entered():
	if(GData.canInteract):
		audio_stream_player.play()
		AnimPlayer.play("Pulse")

func _On_Monitor_Mouse_Exited():
	if(GData.canInteract):
		AnimPlayer.play("RESET")
