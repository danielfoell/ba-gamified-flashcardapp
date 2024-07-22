extends Button

@onready var DeckTitle = $MarginContainer/Panel/DeckTitle
@onready var Options = $Options

signal DeckSelected
signal DeckDeleted

func _ready():
	Options.hide()

func init(title: String):
	DeckTitle.set_text(title)

func _on_pressed():
	DeckSelected.emit()

func _On_BtnOptions_Mouse_Entered():
	Options.show()


func _On_BtnDeleteCard_Pressed():
	StorageService.decks.erase(DeckTitle.text)
	StorageService.DeleteDeck(DeckTitle.text)
	StorageService.saveFlashcards()
	DeckDeleted.emit()


func _On_BtnEditCard_Pressed():
	pass # Replace with function body.


func _On_Options_Mouse_Exited():
	Options.hide()
