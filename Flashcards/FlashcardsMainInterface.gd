extends Control

@onready var animation_player = $Panel/AnimationPlayer
@onready var DeckContainer = $Panel/MainView/HBoxContainer/FolderContainer/ScrollContainer/DeckContainer
@onready var MainView = $Panel/MainView
@onready var DeckView = $Panel/DeckView
@onready var NoCardsView = $Panel/NoCardsView
@onready var DeckTitle = $Panel/DeckView/HBoxContainer/Header/HBoxContainer/DeckTitle
@onready var Progress = $Panel/DeckView/HBoxContainer/Header/Panel/MarginContainer/HBoxContainer/Control/Progress
@onready var ProgressCards = $Panel/DeckView/HBoxContainer/Header/Panel/MarginContainer/HBoxContainer/Control/ProgressCards
@onready var FlashcardsCount = $Panel/DeckView/HBoxContainer/VBoxContainer/HBoxContainer/FlashcardsCount
@onready var FlashcardsContainer = $Panel/DeckView/HBoxContainer/VBoxContainer/ScrollContainer/MarginContainer/FlashcardsContainer
@onready var SearchDeck = $Panel/MainView/HBoxContainer/FolderContainer/HBoxContainer/TE_SearchDeck
@onready var FlashcardsView = $FlashcardsView


const NEW_DECK = preload("res://Flashcards/CreateNewDeckInterface.tscn")
const DECK = preload("res://Flashcards/DeckInterface.tscn")
const CREATE_FLASHCARD = preload("res://Flashcards/CreateFlashcardInterface.tscn")
const FLASHCARD = preload("res://Flashcards/FlashcardInterface.tscn")

func _ready():
	$Panel.show()
	MainView.show()
	DeckView.hide()
	FlashcardsView.hide()
	animation_player.play("Open")
	_LoadDecks()

func _On_BtnExit_Pressed():
	queue_free()

func _LoadDecks():
	if DeckContainer.get_child_count() > 0:
		for child in DeckContainer.get_children():
			child.queue_free()
	for deck in StorageService.decks:
		var Deck = DECK.instantiate()
		DeckContainer.add_child(Deck)
		Deck.init(deck)
		Deck.DeckSelected.connect(_On_DeckSelected.bind(deck))
		Deck.DeckDeleted.connect(_LoadDecks)

func _On_DeckSelected(deck):
	MainView.hide()
	var deckData: Dictionary = StorageService.decks[deck]
	StorageService.currentDeck = deck
	if deckData.is_empty():
		DeckView.hide()
		NoCardsView.show()
	else:
		if FlashcardsContainer.get_child_count() > 0:
			for child in FlashcardsContainer.get_children():
				child.queue_free()
		NoCardsView.hide()
		DeckView.show()
		DeckTitle.set_text(deck)
		ProgressCards.set_text(str(deckData.size()))
		FlashcardsCount.set_text("Karten(%s)" % (str(deckData.size())))
		for question in deckData:
			var Flashcard = FLASHCARD.instantiate()
			Flashcard.FlashcardDeleted.connect(_On_DeckSelected.bind(StorageService.currentDeck))
			Flashcard.FlashcardEditPressed.connect(_On_EditFlashcard)
			Flashcard.FlashcardSelected.connect(_On_FlashcardSelect)
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

func _On_EditFlashcard(flashcard):
	var CreateFlashcard = CREATE_FLASHCARD.instantiate()
	CreateFlashcard.FlashcardCreated.connect(_On_DeckSelected.bind(StorageService.currentDeck))
	get_tree().get_root().add_child(CreateFlashcard)
	CreateFlashcard.Edit(flashcard)

func _On_Btn_Create_New_Flashcards_pressed():
	var CreateFlashcard = CREATE_FLASHCARD.instantiate()
	CreateFlashcard.FlashcardCreated.connect(_On_DeckSelected.bind(StorageService.currentDeck))
	get_tree().get_root().add_child(CreateFlashcard)

func _On_BtnBack_Pressed():
	DeckView.hide()
	NoCardsView.hide()
	MainView.show()

func _On_Search_Deck_Text_Changed():
	for deck in DeckContainer.get_children():
		if deck.DeckTitle.text.to_lower().contains(SearchDeck.text.to_lower()) or SearchDeck.text.is_empty():
			deck.show()
		else:
			deck.hide()

func _On_FlashcardSelect(flashcard):
	FlashcardsView.init(flashcard)
	$Panel.hide()
	FlashcardsView.show()


func _On_BtnClose_Pressed():
	FlashcardsView.hide()
	$Panel.show()
