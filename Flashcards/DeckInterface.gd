extends Button

@onready var DeckTitle = $MarginContainer/TitleBG/DeckTitle
@onready var Options = $Options
@onready var AudioPlayer = $AudioStreamPlayer
@onready var TitleBG = $MarginContainer/TitleBG
@onready var DeckInterface = $"."


signal DeckSelected
signal DeckDeleted

var deck
var preV = modulate.v

func _ready():
	#GData.UnlockAchievement(GData.ACHIEVEMENTS.CREATED_FIRSTCARD)
	Options.hide()

func init(deckData: DeckData):
	deck = deckData
	DeckTitle.set_text(deck.GetName())
	var color = deck.GetColor()
	var styleBox: StyleBoxFlat = self.get_theme_stylebox("normal").duplicate()
	styleBox.set("bg_color", color)
	var new_color = Color.from_hsv(color.h, color.s, color.v - 0.2)
	styleBox.set("border_color", new_color)
	self.add_theme_stylebox_override("normal", styleBox)
	self.add_theme_stylebox_override("hover", styleBox)
	self.add_theme_stylebox_override("pressed", styleBox)
	var styleBox2: StyleBoxFlat = TitleBG.get_theme_stylebox("panel").duplicate()
	styleBox2.set("bg_color", new_color)
	TitleBG.add_theme_stylebox_override("panel", styleBox2)
	preV = modulate.v

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
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:v", modulate.v + 0.1, 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	AudioPlayer.play()


func _On_Deck_Mouse_Exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:v", preV, 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
