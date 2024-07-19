extends Control
#@onready var file_dialog = $Panel/VBoxContainer/Button/NativeFileDialog
@onready var Question = $Panel/MarginContainer/VBoxContainer/Question
@onready var Answer = $Panel/MarginContainer/VBoxContainer/Answer
@onready var BtnAddCard = $Panel/MarginContainer/VBoxContainer/Btn_AddCard
@onready var BtnEditCard = $Panel/MarginContainer/VBoxContainer/Btn_EditCard

signal FlashcardCreated

var oldQuestion

func _ready():
	BtnAddCard.show()
	BtnEditCard.hide()

#func _on_button_pressed():
	#file_dialog.show()

func _on_btn_add_card_pressed():
	StorageService.decks[StorageService.currentDeck][Question.text] = Answer.text
	StorageService.saveFlashcards()
	FlashcardCreated.emit()
	queue_free()


func _On_BtnEditCard_Pressed():
	if oldQuestion != Question.text:
		var deckArray = []
		for key in StorageService.decks[StorageService.currentDeck].keys():
			deckArray.append({key: StorageService.decks[StorageService.currentDeck][key]})
		for i in deckArray.size():
			if oldQuestion in deckArray[i]:
				deckArray.remove_at(i)
				deckArray.insert(i, {Question.text: Answer.text})
				break
		var newDeck = {}
		for deck in deckArray:
			for question in deck.keys():
				newDeck[question] = deck[question]
		StorageService.decks[StorageService.currentDeck] = newDeck
	else:
		StorageService.decks[StorageService.currentDeck][Question.text] = Answer.text
	StorageService.saveFlashcards()
	FlashcardCreated.emit()
	queue_free()

func Edit(flashcardData):
	BtnAddCard.hide()
	BtnEditCard.show()
	print("Deck ", StorageService.decks[StorageService.currentDeck].keys())
	oldQuestion = flashcardData.Question.text
	Question.text = flashcardData.Question.text
	Answer.text = flashcardData.Answer.text
