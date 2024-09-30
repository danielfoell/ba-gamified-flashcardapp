extends Control
#@onready var file_dialog = $Panel/VBoxContainer/Button/NativeFileDialog
@onready var Question = $Panel/MarginContainer/VBoxContainer/Question
@onready var Answer = $Panel/MarginContainer/VBoxContainer/Answer
@onready var BtnAddCard = $Panel/MarginContainer/VBoxContainer/Btn_AddCard
@onready var BtnEditCard = $Panel/MarginContainer/VBoxContainer/Btn_EditCard

signal FlashcardCreated

var flashcard: FlashcardData

func _ready():
	BtnAddCard.show()
	BtnEditCard.hide()

#func _on_button_pressed():
	#file_dialog.show()

func _on_btn_add_card_pressed():
	if Question.text.is_empty() or Answer.text.is_empty(): return
	var currentDeck: DeckData = StorageService.currentDeck
	for flashcard in currentDeck.flashcards:
		if flashcard.question == Question.text:
			print("Frage existiert bereits")
			return
		#if flashcard.question.similarity(Question.text) >= 0.9:
			#print("Frage existiert bereits")
			#return
	flashcard = FlashcardData.new()
	flashcard.question = Question.text
	flashcard.answer = Answer.text
	StorageService.currentDeck.flashcards.append(flashcard)
	StorageService.currentDeck.learningFlashcards.append(flashcard)
	GSignals.RefreshUI.emit()
	StorageService.SaveFlashcards()
	if !GData.user.HasAchievement(GData.ACHIEVEMENTS.keys()[GData.ACHIEVEMENTS.CREATED_FIRSTCARD]):
			GData.user.UnlockAchievement(GData.ACHIEVEMENTS.keys()[GData.ACHIEVEMENTS.CREATED_FIRSTCARD])
	if !GData.user.HasAchievement(GData.ACHIEVEMENTS.keys()[GData.ACHIEVEMENTS.CREATED_TENCARDS]):
		if StorageService.decks.reduce(func(accum, deck): return accum + deck.GetCardCount(), 0) >= 10:
			GData.user.UnlockAchievement(GData.ACHIEVEMENTS.keys()[GData.ACHIEVEMENTS.CREATED_TENCARDS])
	FlashcardCreated.emit()
	queue_free()


func _On_BtnEditCard_Pressed():
	if Question.text.is_empty() or Answer.text.is_empty(): return
	var currentDeck: DeckData = StorageService.currentDeck
	for card in currentDeck.flashcards:
		if card.question == Question.text and card != flashcard:
			print("Frage existiert bereits")
			return
	flashcard.question = Question.text
	flashcard.answer = Answer.text
	GSignals.RefreshUI.emit()
	StorageService.SaveFlashcards()
	FlashcardCreated.emit()
	queue_free()

func Edit(flashcardInterface):
	flashcard = flashcardInterface.flashcard
	BtnAddCard.hide()
	BtnEditCard.show()
	Question.text = flashcard.question
	Answer.text = flashcard.answer
