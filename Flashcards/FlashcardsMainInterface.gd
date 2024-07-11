extends Panel

@onready var animation_player = $AnimationPlayer
@onready var DeckContainer = $MainView/HBoxContainer/FolderContainer/DeckContainer
@onready var MainView = $MainView
@onready var DeckView = $DeckView
@onready var DeckTitle = $DeckView/HBoxContainer/Header/HBoxContainer/DeckTitle
@onready var Progress = $DeckView/HBoxContainer/Header/Panel/MarginContainer/HBoxContainer/Control/Progress
@onready var ProgressCards = $DeckView/HBoxContainer/Header/Panel/MarginContainer/HBoxContainer/Control/ProgressCards
@onready var FlashcardsCount = $DeckView/HBoxContainer/VBoxContainer/FlashcardsCount
@onready var FlashcardsContainer = $DeckView/HBoxContainer/VBoxContainer/ScrollContainer/MarginContainer/FlashcardsContainer

const NEW_DECK = preload("res://Flashcards/CreateNewDeckInterface.tscn")
const DECK = preload("res://Flashcards/DeckInterface.tscn")
const FLASHCARD = preload("res://Flashcards/FlashcardInterface.tscn")

func _ready():
	MainView.show()
	DeckView.hide()
	animation_player.play("Open")
	for deck in StorageService.decks:
		var Deck = DECK.instantiate()
		DeckContainer.add_child(Deck)
		Deck.init(deck)
		Deck.DeckSelected.connect(_On_DeckSelected.bind(deck))


func _on_button_pressed():
	queue_free()


func _On_DeckSelected(deck):
	MainView.hide()
	DeckView.show()
	DeckTitle.set_text(deck)
	var deckFlashcards = StorageService.decks[deck]
	ProgressCards.set_text(str(deckFlashcards.size()))
	FlashcardsCount.set_text("Karten(%s)" % (str(deckFlashcards.size())))
	for question in deckFlashcards:
		var Flashcard = FLASHCARD.instantiate()
		var answer = StorageService.decks[deck].get(question)
		FlashcardsContainer.add_child(Flashcard)
		Flashcard.init(question, answer)
		
		

func _On_Btn_New_Folder_Pressed():
	var CreateNewDeck = NEW_DECK.instantiate()
	get_tree().get_root().add_child(CreateNewDeck)
	var Deck = DECK.instantiate()
	await CreateNewDeck.DeckCreated
	DeckContainer.add_child(Deck)
	var deck = StorageService.decks.keys().back()
	Deck.init(deck)
	Deck.DeckSelected.connect(_On_DeckSelected.bind(deck))
