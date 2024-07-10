extends Button

@onready var DeckTitle = $DeckTitle

signal DeckSelected

func init(title: String):
	DeckTitle.set_text(title)

func _on_pressed():
	DeckSelected.emit()
