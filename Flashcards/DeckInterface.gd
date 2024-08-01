extends Button

@onready var DeckTitle = $MarginContainer/Panel/DeckTitle
@onready var Options = $Options

signal DeckSelected
signal DeckDeleted

var deck

func _ready():
	Options.hide()

func init(deckData: DeckData):
	deck = deckData
	DeckTitle.set_text(deckData.name)

func _on_pressed():
	DeckSelected.emit()

func _On_BtnOptions_Mouse_Entered():
	Options.show()

func _On_BtnDeleteCard_Pressed():
	print("Lol " , StorageService.decks)
	StorageService.decks.erase(deck)
	#StorageService.decks.erase(DeckTitle.text)
	StorageService.DeleteDeck(deck)
	StorageService.saveFlashcards()
	DeckDeleted.emit()

func _On_BtnEditCard_Pressed():
	pass # Replace with function body.

func _On_Options_Mouse_Exited():
	Options.hide()
