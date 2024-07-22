extends Node

#var save_path = "user://flashcards.cards"
var base_save_path = "user://Decks/"
var deck_save_path = "user://Decks/%s.deck"

var flashcards: Array = []
var decks: Dictionary = {}

var currentDeck

func loadFlashcards():
	if not DirAccess.dir_exists_absolute(base_save_path): return
	var dir = DirAccess.open(base_save_path)
	for deck in dir.get_files():
		var file = FileAccess.open(deck_save_path % deck.get_basename(), FileAccess.READ)
		if file:
			decks[deck.get_basename()] = file.get_var()
			file.close
			print("Loaded")
		else:
			print("Failed loading")

func saveFlashcards():
	if not DirAccess.dir_exists_absolute(base_save_path):
		DirAccess.make_dir_absolute(base_save_path)
	for deck in decks:
		var flashcards = decks[deck]
		var file = FileAccess.open(deck_save_path % deck, FileAccess.WRITE)
		if file:
			file.store_var(flashcards)
			file.close()
		else:
			print("Failed saving")

func DeleteDeck(deck):
	DirAccess.remove_absolute(deck_save_path % deck)
