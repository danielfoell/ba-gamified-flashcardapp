extends Control
@onready var file_dialog = $Panel/VBoxContainer/Button/NativeFileDialog
@onready var question = $Panel/VBoxContainer/Question
@onready var answer = $Panel/VBoxContainer/Answer


func _ready():
	#if ResourceLoader.exists("user://test.res"):
		#var data = ResourceLoader.load("user://test.res")
		#print(data)
	StorageService.loadFlashcards()

func _on_button_pressed():
	file_dialog.show()

func _on_btn_add_card_pressed():
	#var flashcard: FlashcardData = FlashcardData.new()
	#flashcard.question = question.text
	#flashcard.answer = answer.text
	#ResourceSaver.save(flashcard, "user://test.res")
	#print("es")
	StorageService.flashcards.append({"question": question.text, "answer": answer.text})
	StorageService.saveFlashcards()
