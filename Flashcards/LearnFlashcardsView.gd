extends Panel

@onready var Question = $CardView/VBoxContainer/Question
@onready var Answer = $CardView/VBoxContainer/Answer
@onready var CardsCount = $Header/MarginContainer/HBoxContainer/Panel/MarginContainer/CardsCount
@onready var Progress = $Header/MarginContainer/HBoxContainer/Progress
@onready var CardView = $CardView
@onready var EndView = $EndView
@onready var BtnBad = $Buttons/HBoxContainer/BtnBad
@onready var BtnGood = $Buttons/HBoxContainer/BtnGood


var currentFlashcard: FlashcardData
var currentDeck: DeckData
var cardsLeft: Array[FlashcardData]

func _ready():
	EndView.hide()
	currentDeck = StorageService.currentDeck
	currentFlashcard = currentDeck.learningFlashcards.front()
	CardsCount.text = "%s/%s" % [0, currentDeck.learningFlashcards.size()]
	Question.text = currentFlashcard.question
	Answer.text = currentFlashcard.answer
	Progress.set_max(currentDeck.learningFlashcards.size())
	Progress.set_value(0)

func _On_BtnBad_Pressed():
	BtnBad.disabled = true
	BtnGood.disabled = true
	currentFlashcard.learned = false
	cardsLeft.append(currentFlashcard)
	SetNextFlashcard()

func _On_BtnGood_Pressed():
	BtnBad.disabled = true
	BtnGood.disabled = true
	currentFlashcard.learned = true
	SetNextFlashcard()

func GetNextFlashcard():
	if currentDeck.learningFlashcards.find(currentFlashcard) + 1 >= currentDeck.learningFlashcards.size(): 
		return currentDeck.learningFlashcards.back()
	else:
		return currentDeck.learningFlashcards[currentDeck.learningFlashcards.find(currentFlashcard) + 1]

func SetNextFlashcard():
	var tween = get_tree().create_tween()
	tween.tween_property(Progress, "value", Progress.get_value() + 1, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	if currentFlashcard == currentDeck.learningFlashcards.back():
		CardsCount.text = "%s/%s" % [currentDeck.learningFlashcards.size(), currentDeck.learningFlashcards.size()]
		await tween.finished
		CardView.hide()
		EndView.show()
	else:
		currentFlashcard = GetNextFlashcard()
		CardsCount.text = "%s/%s" % [currentDeck.learningFlashcards.find(currentFlashcard), currentDeck.learningFlashcards.size()]
		Question.text = currentFlashcard.question
		Answer.text = currentFlashcard.answer
	await tween.finished
	BtnBad.disabled = false
	BtnGood.disabled = false
	
func _On_BtnClose_Pressed():
	queue_free()

func _On_BtnContinue_Pressed():
	BtnBad.disabled = false
	BtnGood.disabled = false
	currentDeck.learningFlashcards = cardsLeft.duplicate()
	cardsLeft.clear()
	EndView.hide()
	CardView.show()
	currentFlashcard = currentDeck.learningFlashcards.front()
	CardsCount.text = "%s/%s" % [0, currentDeck.learningFlashcards.size()]
	Question.text = currentFlashcard.question
	Answer.text = currentFlashcard.answer
	Progress.set_max(currentDeck.learningFlashcards.size())
	Progress.set_value(0)
