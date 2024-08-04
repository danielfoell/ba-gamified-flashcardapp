extends Panel

@onready var Question = $MarginContainer/VBoxContainer/Question
@onready var Answer = $MarginContainer/VBoxContainer/Answer
@onready var CardsCount = $Header/MarginContainer/HBoxContainer/Panel/MarginContainer/CardsCount
@onready var Progress = $Header/MarginContainer/HBoxContainer/Progress

var currentFlashcard: FlashcardData
var currentDeck: DeckData

func _ready():
	currentDeck = StorageService.currentDeck
	currentFlashcard = currentDeck.learningFlashcards.front()
	CardsCount.text = "%s/%s" % [1, currentDeck.learningFlashcards.size()]
	Progress.set_max(currentDeck.learningFlashcards.size())
	Progress.set_value(0)

func _On_BtnBad_Pressed():
	pass # Replace with function body.

func _On_BtnGood_Pressed():
	SetNextFlashcard()


func GetNextFlashcard():
	return currentDeck.learningFlashcards[currentDeck.learningFlashcards.find(currentFlashcard) + 1]

func SetNextFlashcard():
	currentFlashcard = GetNextFlashcard()
	var tween = get_tree().create_tween()
	#Progress.set_value(Progress.get_value() + 1)
	tween.tween_property(Progress, "value", 2, 1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	#tween.play()
	
	CardsCount.text = "%s/%s" % [currentDeck.learningFlashcards.find(currentFlashcard) + 1, currentDeck.learningFlashcards.size()]
