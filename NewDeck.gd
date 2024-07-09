extends Panel

@onready var Deckname = $MarginContainer/VBoxContainer/MarginContainer/TextEdit
const MAIN = preload("res://Main.tscn")

func _on_button_pressed():
	if Deckname.text.length() < 1:
		print("Kein Deckname")
	else:
		StorageService.decks[Deckname.text] = {}
		queue_free()
		if StorageService.decks.size() == 1:
			get_tree().get_root().add_child(MAIN.instantiate())
