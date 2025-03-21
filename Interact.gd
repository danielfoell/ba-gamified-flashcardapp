extends StaticBody3D

@onready var animation_player = $AnimationPlayer
@onready var audio_stream_player = $AudioStreamPlayer


const NEWDECK = preload("res://Flashcards/CreateNewDeckInterface.tscn")
const MAIN = preload("res://Main.tscn")

func _ready():
	animation_player.play("RESET")

func _on_input_event(camera, event, position, normal, shape_idx):
	if(GData.canInteract):
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
				if StorageService.decks.is_empty():
					get_tree().get_root().add_child(NEWDECK.instantiate())
				else:
					get_tree().get_root().add_child(MAIN.instantiate())


func _on_mouse_entered():
	if(GData.canInteract):
		audio_stream_player.play()
		animation_player.play("Pulse")
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	animation_player.play("RESET")
