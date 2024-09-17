extends Button

@onready var Question = $HBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/Question
@onready var Answer = $HBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/Answer
@onready var Options = $HBoxContainer/Options
@onready var BtnCardOptions = $HBoxContainer/MarginContainer/HBoxContainer/Control/BtnCardOptions


signal FlashcardDeleted
signal FlashcardEditPressed
signal FlashcardSelected

var flashcard

func init(flashcardData: FlashcardData):
	flashcard = flashcardData
	Question.set_text(flashcard.question)
	Answer.set_text(flashcard.answer)


func _On_BtnCardOptions_pressed():
	pass
	#Options.reparent(get_tree().get_root())
	#Options.show()
	#Options.global_position = $MarginContainer/HBoxContainer/Control/BtnCardOptions.global_position + Vector2(0, 32)

#func _input(event):
	#if event is InputEventMouseButton:
		#if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			#if not Rect2(Vector2(), Options.get_global_rect().size).has_point(get_local_mouse_position()): 
				#Options.hide()

func _On_BtnDeleteCard_pressed():
	StorageService.currentDeck.flashcards.erase(flashcard)
	StorageService.currentDeck.learningFlashcards.erase(flashcard)
	StorageService.saveFlashcards()
	GSignals.RefreshUI.emit()
	FlashcardDeleted.emit()


func _On_BtnEditCard_Pressed():
	FlashcardEditPressed.emit(self)


func _On_Mouse_Entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _On_Mouse_Exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _On_BtnCardOptions_Mouse_Entered():
	BtnCardOptions.hide()
	Options.show()


func _On_Options_Mouse_Exited():
	BtnCardOptions.show()
	Options.hide()


func _On_Flashcard_Pressed():
	FlashcardSelected.emit(flashcard)
