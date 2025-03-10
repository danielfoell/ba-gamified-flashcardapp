extends Control

@onready var animation_player = $Panel/AnimationPlayer
@onready var DeckContainer = $Panel/MainView/HBoxContainer/FolderContainer/ScrollContainer/DeckContainer
@onready var MainView = $Panel/MainView
@onready var DeckView = $Panel/DeckView
@onready var NoCardsView = $Panel/NoCardsView
@onready var DeckTitle = $Panel/DeckView/HBoxContainer/Header/HBoxContainer/DeckTitle
@onready var Progress = $Panel/DeckView/HBoxContainer/Header/Panel/MarginContainer/HBoxContainer/HBoxContainer/Control/Progress
@onready var CardsLeft = $Panel/DeckView/HBoxContainer/Header/Panel/MarginContainer/HBoxContainer/HBoxContainer/Control/VBoxContainer/CardsLeft
@onready var CardsLearned = $Panel/DeckView/HBoxContainer/Header/Panel/MarginContainer/HBoxContainer/HBoxContainer/Control/VBoxContainer/CardsLearned
@onready var FlashcardsCount = $Panel/DeckView/HBoxContainer/VBoxContainer/HBoxContainer/FlashcardsCount
@onready var FlashcardsContainer = $Panel/DeckView/HBoxContainer/VBoxContainer/ScrollContainer/MarginContainer/FlashcardsContainer
@onready var SearchDeck = $Panel/MainView/HBoxContainer/FolderContainer/HBoxContainer/TE_SearchDeck
@onready var FlashcardsView = $FlashcardsView
@onready var SearchFlashcard = $Panel/DeckView/HBoxContainer/VBoxContainer/HBoxContainer/TextEdit
@onready var Btn_ClearSearch = $Panel/DeckView/HBoxContainer/VBoxContainer/HBoxContainer/TextEdit/Btn_Search_Clear
@onready var BtnBack = $Panel/BtnBack


const NEW_DECK = preload("res://Flashcards/CreateNewDeckInterface.tscn")
const DECK = preload("res://Flashcards/DeckInterface.tscn")
const CREATE_FLASHCARD = preload("res://Flashcards/CreateFlashcardInterface.tscn")
const FLASHCARD = preload("res://Flashcards/FlashcardInterface.tscn")
const LEARNDECK = preload("res://Flashcards/LearnFlashcardsView.tscn")


func _ready():
	GData.canInteract = false
	$Panel.show()
	BtnBack.hide()
	MainView.show()
	DeckView.hide()
	FlashcardsView.hide()
	animation_player.play("Open")
	GSignals.RefreshUI.connect(_RefreshUI)
	_LoadDecks()

func _On_BtnExit_Pressed():
	if GData.user.tutorialStage == TutorialService.TUTORIALSTAGE.FIRSTLEVELUP and has_user_signal("closed"):
		emit_signal("closed")
	queue_free()
	GData.canInteract = true

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

func _On_DeckSelected(deckData: DeckData):
	MainView.hide()
	var deck: DeckData = StorageService.decks[StorageService.decks.find(deckData)]
	StorageService.currentDeck = deck
	if deck.flashcards.is_empty():
		DeckView.hide()
		NoCardsView.show()
		BtnBack.show()
	else:
		if FlashcardsContainer.get_child_count() > 0:
			for child in FlashcardsContainer.get_children():
				child.queue_free()
		NoCardsView.hide()
		DeckView.show()
		BtnBack.show()
		Btn_ClearSearch.hide()
		DeckTitle.set_text(deck.name)
		FlashcardsCount.set_text("Karten(%s)" % (str(deck.flashcards.size())))
		for flashcard: FlashcardData in deck.flashcards:
			var Flashcard = FLASHCARD.instantiate()
			Flashcard.FlashcardDeleted.connect(_On_DeckSelected.bind(StorageService.currentDeck))
			Flashcard.FlashcardEditPressed.connect(_On_EditFlashcard)
			Flashcard.FlashcardSelected.connect(_On_FlashcardSelect)
			FlashcardsContainer.add_child(Flashcard)
			Flashcard.init(flashcard)
		#if deck.GetLearningFlashcards().is_empty():
			#deck.learningFlashcards = deck.flashcards.duplicate()
			#for card in deck.learningFlashcards:
				#if card.learned == false: deck.learningFlashcards.append(card)
		#else:
			#deck.flashcards = deck.flashcards.duplicate()
			#deck.learningFlashcards.clear()
			#for card in deck.flashcards:
				#if card.learned == false: 
					#deck.learningFlashcards + [card]
		Progress.set_max(deck.flashcards.size())
		Progress.set_value(deck.GetLearnedFlashcards().size())
		CardsLeft.set_text(str(deck.GetLearningFlashcards().size()))
		CardsLearned.set_text(str(deck.GetLearnedFlashcards().size()))

func _On_Btn_New_Folder_Pressed():
	var CreateNewDeck = NEW_DECK.instantiate()
	add_child(CreateNewDeck)
	var Deck = DECK.instantiate()
	await CreateNewDeck.DeckCreated
	DeckContainer.add_child(Deck)
	var deck: DeckData = StorageService.decks.back()
	Deck.init(deck)
	Deck.DeckSelected.connect(_On_DeckSelected.bind(deck))

func _On_EditFlashcard(flashcard):
	var CreateFlashcard = CREATE_FLASHCARD.instantiate()
	CreateFlashcard.FlashcardCreated.connect(_On_DeckSelected.bind(StorageService.currentDeck))
	add_child(CreateFlashcard)
	CreateFlashcard.Edit(flashcard)

func _On_Btn_Create_New_Flashcards_pressed():
	var CreateFlashcard = CREATE_FLASHCARD.instantiate()
	add_child(CreateFlashcard)
	CreateFlashcard.FlashcardCreated.connect(_On_DeckSelected.bind(StorageService.currentDeck))
	#StorageService.currentDeck.learningFlashcards + [CreateFlashcard.flashcard]
	await CreateFlashcard.FlashcardCreated
	#ProgressCards.set_text(str(StorageService.currentDeck.GetLearningFlashcards().size()))

func _On_BtnBack_Pressed():
	DeckView.hide()
	NoCardsView.hide()
	MainView.show()
	BtnBack.hide()

func _On_Search_Deck_Text_Changed(text):
	for deck in DeckContainer.get_children():
		if deck.DeckTitle.text.to_lower().contains(text.to_lower()) or text.is_empty():
			deck.show()
		else:
			deck.hide()

func _On_Search_Flashcard_Text_Changed(text):
	for card in FlashcardsContainer.get_children():
		if card.Question.text.to_lower().contains(text.to_lower()) or card.Answer.text.to_lower().contains(text.to_lower()) or text.is_empty():
			card.show()
		else:
			card.hide()

func _On_FlashcardSelect(flashcard: FlashcardData):
	FlashcardsView.init(flashcard)
	$Panel.hide()
	FlashcardsView.show()

func _On_BtnClose_Pressed():
	FlashcardsView.hide()
	$Panel.show()

func _On_BtnLearn_Pressed():
	var LearnDeck = LEARNDECK.instantiate()
	hide()
	get_tree().get_root().add_child(LearnDeck)

func _RefreshUI():
	CardsLeft.set_text(str(StorageService.currentDeck.GetLearningFlashcards().size()))
	CardsLearned.set_text(str(StorageService.currentDeck.GetLearnedFlashcards().size()))
	Progress.set_max(StorageService.currentDeck.flashcards.size())
	Progress.set_value(StorageService.currentDeck.GetLearnedFlashcards().size())
