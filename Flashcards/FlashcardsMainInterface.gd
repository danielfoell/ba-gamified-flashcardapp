extends Panel

@onready var animation_player = $AnimationPlayer
@onready var DeckContainer = $MainView/HBoxContainer/FolderContainer/ScrollContainer/DeckContainer
@onready var MainView = $MainView
@onready var DeckView = $DeckView
@onready var NoCardsView = $NoCardsView
@onready var DeckTitle = $DeckView/HBoxContainer/Header/HBoxContainer/DeckTitle
@onready var Progress = $DeckView/HBoxContainer/Header/Panel/MarginContainer/HBoxContainer/Control/Progress
@onready var ProgressCards = $DeckView/HBoxContainer/Header/Panel/MarginContainer/HBoxContainer/Control/ProgressCards
@onready var FlashcardsCount = $DeckView/HBoxContainer/VBoxContainer/HBoxContainer/FlashcardsCount
@onready var FlashcardsContainer = $DeckView/HBoxContainer/VBoxContainer/ScrollContainer/MarginContainer/FlashcardsContainer
@onready var SearchDeck = $MainView/HBoxContainer/FolderContainer/HBoxContainer/TE_SearchDeck

const NEW_DECK = preload("res://Flashcards/CreateNewDeckInterface.tscn")
const DECK = preload("res://Flashcards/DeckInterface.tscn")
const CREATE_FLASHCARD = preload("res://Flashcards/CreateFlashcardInterface.tscn")
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

func _on_btn_back_pressed():
	DeckView.hide()
	NoCardsView.hide()
	MainView.show()

func _On_Search_Deck_Text_Changed():
	for deck in DeckContainer.get_children():
		if deck.DeckTitle.text.contains(SearchDeck.text) or SearchDeck.text.is_empty():
			deck.show()
		else:
			deck.hide()
