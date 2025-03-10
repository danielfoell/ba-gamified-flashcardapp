extends Panel

@onready var Deckname = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/TextEdit
@onready var BtnColorPicker = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Control/BtnColorPicker

const MAIN = preload("res://Main.tscn")

signal DeckCreated

func _ready():
	GData.canInteract = false
	BtnColorPicker.color = Color.AQUA

func _on_button_pressed():
	if Deckname.text.length() < 1:
		print("Kein Deckname")
	elif StorageService.decks.map(func(deck): return deck.name).has(Deckname.text):
		print("Deck existiert bereits")
	#elif StorageService.decks.has(Deckname.text):
		#print("Deck existiert bereits")
	else:
		var deck = DeckData.new()
		deck.name = Deckname.text
		deck.SetColor(BtnColorPicker.color)
		StorageService.decks.append(deck)
		StorageService.SaveFlashcards()
		queue_free()
		DeckCreated.emit()
		if StorageService.decks.size() == 1:
			get_tree().get_root().add_child(MAIN.instantiate())
		if !GData.user.HasAchievement(GData.ACHIEVEMENTS.keys()[GData.ACHIEVEMENTS.CREATED_FIRSTDECK]):
			GData.user.UnlockAchievement(GData.ACHIEVEMENTS.keys()[GData.ACHIEVEMENTS.CREATED_FIRSTDECK])


func _On_BtnClose_Pressed():
	queue_free()
	GData.canInteract = true
