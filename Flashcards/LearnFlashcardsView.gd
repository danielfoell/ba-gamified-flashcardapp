extends Panel

@onready var Question = $MarginContainer/VBoxContainer/Question
@onready var Answer = $MarginContainer/VBoxContainer/Answer
@onready var CardsCount = $Header/MarginContainer/HBoxContainer/Panel/MarginContainer/CardsCount
@onready var Progress = $Header/MarginContainer/HBoxContainer/Progress

var currentFlashcard: FlashcardData

func _ready():
	var currentDeck: DeckData = StorageService.currentDeck
	currentFlashcard = currentDeck.learningFlashcards.front()
	CardsCount.text = "%s/%s" % [1, currentDeck.learningFlashcards.size()]
	Progress.set_max(currentDeck.learningFlashcards.size())
	Progress.set_value(0)

func _process(delta):
	pass
