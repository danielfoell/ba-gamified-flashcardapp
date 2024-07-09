extends Node

var save_path = "user://flashcards.cards"

var flashcards: Array = []
var decks: Dictionary = {}

func loadFlashcards():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file:
			decks = file.get_var()
			file.close()
			print("Loaded")
		else:
			print("Fail")
	else:
		print("File does not exist")

func saveFlashcards():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_var(decks)
		file.close()
		print("Saved")
	else:
		print("Fail")
