extends Button

@onready var Question = $MarginContainer/HBoxContainer/VBoxContainer/Question
@onready var Answer = $MarginContainer/HBoxContainer/VBoxContainer/Answer

func init(question, answer):
	Question.set_text(question)
	Answer.set_text(answer)
