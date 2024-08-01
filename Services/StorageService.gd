extends Node

#var save_path = "user://flashcards.cards"
var base_save_path = "user://Decks/"
var deck_save_path = "user://Decks/%s.deck"

var flashcards: Array = []
#var decks: Dictionary = {}

var decks: Array[DeckData]

var currentDeck

func loadFlashcards():
	if not DirAccess.dir_exists_absolute(base_save_path): return
	var dir = DirAccess.open(base_save_path)
	for deck in dir.get_files():
		var file = FileAccess.open(deck_save_path % deck.get_basename(), FileAccess.READ)
		if file:
			var newDeck = DeckData.new()
			newDeck.name = deck.get_basename()
			var flashcards = file.get_var()
			for flashcard in flashcards:
				var newFlashcard = FlashcardData.new()
				newFlashcard.question = flashcard["question"]
				newFlashcard.answer = flashcard["answer"]
				newFlashcard.answer_visible = flashcard["answer_visible"]
				newDeck.flashcards.append(newFlashcard)
			decks.append(newDeck)
			file.close
			print("Loaded")
		else:
			print("Failed loading")

func saveFlashcards():
	if not DirAccess.dir_exists_absolute(base_save_path):
		DirAccess.make_dir_absolute(base_save_path)
	for deck in decks:
		var flashcards = deck.flashcards
		var flashcardsConverted: Array
		for flashcard in flashcards:
			flashcardsConverted.append({
				"question": flashcard.question,
				"answer": flashcard.answer,
				"answer_visible": flashcard.answer_visible
			})
		var file = FileAccess.open(deck_save_path % deck.name, FileAccess.WRITE)
		if file:
			file.store_var(flashcardsConverted)
			file.close()
			print("Saved")
		else:
			print("Failed saving")

func DeleteDeck(deck: DeckData):
	DirAccess.remove_absolute(deck_save_path % deck.name)
