extends Control
#@onready var file_dialog = $Panel/VBoxContainer/Button/NativeFileDialog
@onready var question = $Panel/MarginContainer/VBoxContainer/Question
@onready var answer = $Panel/MarginContainer/VBoxContainer/Answer

signal FlashcardCreated

#func _on_button_pressed():
	#file_dialog.show()

func _on_btn_add_card_pressed():
	StorageService.decks[StorageService.currentDeck][question.text] = answer.text
	StorageService.saveFlashcards()
	FlashcardCreated.emit()
	queue_free()
