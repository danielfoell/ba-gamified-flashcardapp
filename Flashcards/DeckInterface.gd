extends Button

@onready var DeckTitle = $MarginContainer/Panel/DeckTitle
@onready var Options = $Options

signal DeckSelected
signal DeckDeleted

var deck

func _ready():
	#GData.UnlockAchievement(GData.ACHIEVEMENTS.CREATED_FIRSTCARD)
	Options.hide()

func init(deckData: DeckData):
	deck = deckData
	DeckTitle.set_text(deckData.name)

func _on_pressed():
	DeckSelected.emit()

func _On_BtnOptions_Mouse_Entered():
	Options.show()

func _On_BtnDeleteCard_Pressed():
	StorageService.decks.erase(deck)
	StorageService.DeleteDeck(deck)
	StorageService.SaveFlashcards()
	DeckDeleted.emit()

func _On_BtnEditCard_Pressed():
	pass # Replace with function body.

func _On_Options_Mouse_Exited():
	Options.hide()
