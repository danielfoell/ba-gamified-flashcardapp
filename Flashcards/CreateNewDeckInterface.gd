extends Panel

@onready var Deckname = $MarginContainer/VBoxContainer/MarginContainer/TextEdit
const MAIN = preload("res://Main.tscn")

signal DeckCreated

func _on_button_pressed():
	if Deckname.text.length() < 1:
		print("Kein Deckname")
	elif StorageService.decks.has(Deckname.text):
		print("Deck existiert bereits")
	else:
		StorageService.decks[Deckname.text] = {}
		queue_free()
		DeckCreated.emit()
		if StorageService.decks.size() == 1:
			get_tree().get_root().add_child(MAIN.instantiate())
