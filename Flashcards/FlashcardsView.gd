extends Panel

@onready var Question = $MarginContainer/VBoxContainer/Question
@onready var Answer = $MarginContainer/VBoxContainer/Answer
@onready var CardsCount = $Panel/MarginContainer/CardsCount
@onready var panel = $"../Panel"

var deckArray = []

func init(flashcard):
	deckArray.clear()
	Question.text = flashcard.Question.text
	Answer.text = flashcard.Answer.text
	for key in StorageService.decks[StorageService.currentDeck].keys():
		deckArray.append({key: StorageService.decks[StorageService.currentDeck][key]})
	CardsCount.text = "%s/%s" % [deckArray.find({flashcard.Question.text: flashcard.Answer.text}) + 1, StorageService.decks[StorageService.currentDeck].size()]
	Answer.visible = false

func _input(event):
	if visible:
		if Input.is_action_just_pressed("LMB") and Rect2(Vector2(), get_global_rect().size).has_point(get_local_mouse_position()):
			Answer.visible = !Answer.visible
		elif Input.is_action_just_pressed("SPACE"):
			Answer.visible = !Answer.visible
		elif Input.is_action_just_pressed("LMB") and not Rect2(Vector2(), $MouseArea.get_global_rect().size).has_point(get_local_mouse_position()):
			visible = false
			panel.show()
		elif Input.is_action_just_pressed("LEFT"):
			_On_BtnLeft_Pressed()
		elif Input.is_action_just_pressed("RIGHT"):
			_On_BtnRight_Pressed()
	

func _On_BtnRight_Pressed():
	var card
	if deckArray.find({Question.text: Answer.text}) + 1 >= deckArray.size():
		card = deckArray.front()
	else:
		card = deckArray[deckArray.find({Question.text: Answer.text}) + 1]
	Question.text = card.keys()[0]
	Answer.text = card.values()[0]
	Answer.visible = false
	CardsCount.text = "%s/%s" % [deckArray.find({card.keys()[0]: card.values()[0]}) + 1, StorageService.decks[StorageService.currentDeck].size()]


func _On_BtnLeft_Pressed():
	var card = deckArray[deckArray.find({Question.text: Answer.text}) - 1]
	Question.text = card.keys()[0]
	Answer.text = card.values()[0]
	Answer.visible = false
	CardsCount.text = "%s/%s" % [deckArray.find({card.keys()[0]: card.values()[0]}) + 1, StorageService.decks[StorageService.currentDeck].size()]
