extends Button

@onready var DeckTitle = $MarginContainer/Panel/DeckTitle
@onready var Options = $Options
@onready var AudioPlayer = $AudioStreamPlayer

signal DeckSelected
signal DeckDeleted

var deck
var preV = modulate.v

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


func _On_Deck_Mouse_Entered():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:v", modulate.v + 0.1, 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	AudioPlayer.play()



func _On_Deck_Mouse_Exited():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:v", preV, 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
