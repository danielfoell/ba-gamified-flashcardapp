extends Panel

@onready var Question = $CardView/VBoxContainer/Question
@onready var Answer = $CardView/VBoxContainer/Answer
@onready var CardsCount = $Header/MarginContainer/HBoxContainer/Panel/MarginContainer/CardsCount
@onready var Progress = $Header/MarginContainer/HBoxContainer/Progress
@onready var CardView = $CardView
@onready var EndCardLeftView = $EndCardLeftView
@onready var EndFinishedView = $EndFinishedView
@onready var BtnBad = $Buttons/HBoxContainer/BtnBad
@onready var BtnGood = $Buttons/HBoxContainer/BtnGood
@onready var AudioPlayer = $AudioStreamPlayer
@onready var Xp = $Xp


var currentFlashcard: FlashcardData
var currentDeck: DeckData
var cardsLeft: Array[FlashcardData]

func _ready():
	EndCardLeftView.hide()
	EndFinishedView.hide()
	currentDeck = StorageService.currentDeck
	if currentDeck.GetLearningFlashcards().is_empty():
		currentDeck.learningFlashcards = currentDeck.flashcards
		for card in currentDeck.learningFlashcards:
			card.learned = false
	#else:
		#currentDeck.flashcards = currentDeck.flashcards.duplicate()
		#currentDeck.learningFlashcards.clear()
		#for card in currentDeck.flashcards:
			#if card.learned == false: 
				#currentDeck.learningFlashcards + [card]
	currentFlashcard = currentDeck.GetLearningFlashcards().front()
	CardsCount.text = "%s/%s" % [0, currentDeck.GetLearningFlashcards().size()]
	Question.text = currentFlashcard.question
	Answer.text = currentFlashcard.answer
	Answer.visible = false
	Progress.set_max(currentDeck.GetLearningFlashcards().size())
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
	currentFlashcard.last_learned = Time.get_datetime_dict_from_system()
	GData.user.AddExp(GData.data.get("EXP")["CARD_SOLVED"])
	AudioPlayer.play()
	#var label = Label.new()
	#label.set_text("+25")
	Xp.show()
	#BtnGood.add_child(label)
	var tween = get_tree().create_tween()
	tween.tween_property(Xp, "position:y", -2, 2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel()
	tween.tween_property(Xp, "modulate:a", 0, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	SetNextFlashcard()
	await tween.finished
	#Xp.hide()

func GetNextFlashcard():
	if currentDeck.GetLearningFlashcards().find(currentFlashcard) + 1 >= currentDeck.GetLearningFlashcards().size(): 
		return currentDeck.GetLearningFlashcards().back()
	else:
		return currentDeck.GetLearningFlashcards()[currentDeck.GetLearningFlashcards().find(currentFlashcard) + 1]

func SetNextFlashcard():
	StorageService.SaveFlashcards()
	var tween = get_tree().create_tween()
	tween.tween_property(Progress, "value", Progress.get_value() + 1, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	if currentFlashcard == currentDeck.GetLearningFlashcards().back():
		CardsCount.text = "%s/%s" % [currentDeck.GetLearningFlashcards().size(), currentDeck.GetLearningFlashcards().size()]
		await tween.finished
		CardView.hide()
		if cardsLeft.is_empty():
			EndFinishedView.show()
		else:
			EndCardLeftView.show()
	else:
		currentFlashcard = GetNextFlashcard()
		CardsCount.text = "%s/%s" % [currentDeck.GetLearningFlashcards().find(currentFlashcard), currentDeck.GetLearningFlashcards().size()]
		Question.text = currentFlashcard.question
		Answer.text = currentFlashcard.answer
	Answer.visible = false
	await tween.finished
	BtnBad.disabled = false
	BtnGood.disabled = false
	
func _On_BtnClose_Pressed():
	for card in currentDeck.GetLearningFlashcards():
		if card.learned == false:
			if !cardsLeft.has(card):
				cardsLeft.append(card)
	currentDeck.learningFlashcards = cardsLeft.duplicate()
	StorageService.SaveFlashcards()
	GSignals.RefreshUI.emit()
	queue_free()
	get_tree().get_root().get_child(6).show()

func _On_BtnContinue_Pressed():
	Answer.visible = false
	BtnBad.disabled = false
	BtnGood.disabled = false
	currentDeck.learningFlashcards = cardsLeft.duplicate()
	cardsLeft.clear()
	EndCardLeftView.hide()
	CardView.show()
	currentFlashcard = currentDeck.GetLearningFlashcards().front()
	CardsCount.text = "%s/%s" % [0, currentDeck.GetLearningFlashcards().size()]
	Question.text = currentFlashcard.question
	Answer.text = currentFlashcard.answer
	Progress.set_max(currentDeck.GetLearningFlashcards().size())
	Progress.set_value(0)

func _input(event):
	if visible:
		if Input.is_action_just_pressed("LMB") and Rect2(Vector2(), get_global_rect().size).has_point(get_local_mouse_position()) or Input.is_action_just_pressed("SPACE"):
			Answer.visible = !Answer.visible
			currentFlashcard.answer_visible = !currentFlashcard.answer_visible
			StorageService.SaveFlashcards()
		elif Input.is_action_just_pressed("LEFT"):
			_On_BtnBad_Pressed()
		elif Input.is_action_just_pressed("RIGHT"):
			_On_BtnGood_Pressed()
