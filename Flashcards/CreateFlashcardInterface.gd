extends Control
#@onready var file_dialog = $Panel/VBoxContainer/Button/NativeFileDialog
@onready var Question = $Panel/MarginContainer/VBoxContainer/Question
@onready var Answer = $Panel/MarginContainer/VBoxContainer/Answer
@onready var BtnAddCard = $Panel/MarginContainer/VBoxContainer/Btn_AddCard
@onready var BtnEditCard = $Panel/MarginContainer/VBoxContainer/Btn_EditCard
@onready var StatusText = $Panel/MarginContainer/VBoxContainer/StatusText

signal FlashcardCreated

var flashcard: FlashcardData

func _ready():
	BtnAddCard.show()
	BtnEditCard.hide()
	StatusText.hide()

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
	var tween = get_tree().create_tween()
	tween.tween_property($Toast, "position:y", 330, 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_interval(1)
	tween.tween_property($Toast, "position:y", 250, 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	Question.text = ""
	Answer.text = ""
	#queue_free()


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


func _on_question_text_changed():
	var currentDeck: DeckData = StorageService.currentDeck
	var cardExists = false
	for card in currentDeck.flashcards:
		if card.question == Question.text:
			cardExists = true
	if cardExists:
		StatusText.show()
		BtnAddCard.hide()
		BtnEditCard.hide()
		print("Frage existiert bereits")
	else:
		StatusText.hide()
		BtnAddCard.show()
		#BtnEditCard.show()


func _on_btn_close_pressed():
	queue_free()
