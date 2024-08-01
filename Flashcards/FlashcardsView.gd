extends Panel

@onready var Question = $MarginContainer/VBoxContainer/Question
@onready var Answer = $MarginContainer/VBoxContainer/Answer
@onready var CardsCount = $Panel/MarginContainer/CardsCount
@onready var panel = $"../Panel"

var currentDeck: DeckData
var currentFlashcard: FlashcardData

func init(flashcard: FlashcardData):
	currentDeck = StorageService.currentDeck
	currentFlashcard = flashcard
	Question.text = currentFlashcard.question
	Answer.text = currentFlashcard.answer
	CardsCount.text = "%s/%s" % [currentDeck.flashcards.find(currentFlashcard) + 1, currentDeck.flashcards.size()]
	Answer.visible = currentFlashcard.answer_visible

func _input(event):
	if visible:
		if Input.is_action_just_pressed("LMB") and Rect2(Vector2(), get_global_rect().size).has_point(get_local_mouse_position()) or Input.is_action_just_pressed("SPACE"):
			Answer.visible = !Answer.visible
			currentFlashcard.answer_visible = !currentFlashcard.answer_visible
			StorageService.saveFlashcards()
		#elif Input.is_action_just_pressed("LMB") and not Rect2(Vector2(), $MouseArea.get_rect().size).has_point(get_local_mouse_position()):
			#visible = false
			#panel.show()
		elif Input.is_action_just_pressed("LEFT"):
			_On_BtnLeft_Pressed()
		elif Input.is_action_just_pressed("RIGHT"):
			_On_BtnRight_Pressed()
	

func _On_BtnRight_Pressed():
	if currentDeck.flashcards.find(currentFlashcard) + 1 >= currentDeck.flashcards.size():
		currentFlashcard = currentDeck.flashcards.front()
	else:
		currentFlashcard = currentDeck.flashcards[currentDeck.flashcards.find(currentFlashcard) + 1]
	Question.text = currentFlashcard.question
	Answer.text = currentFlashcard.answer
	Answer.visible = currentFlashcard.answer_visible
	CardsCount.text = "%s/%s" % [currentDeck.flashcards.find(currentFlashcard) + 1, currentDeck.flashcards.size()]


func _On_BtnLeft_Pressed():
	currentFlashcard = currentDeck.flashcards[currentDeck.flashcards.find(currentFlashcard) - 1]
	Question.text = currentFlashcard.question
	Answer.text = currentFlashcard.answer
	Answer.visible = currentFlashcard.answer_visible
	CardsCount.text = "%s/%s" % [currentDeck.flashcards.find(currentFlashcard) + 1, currentDeck.flashcards.size()]
