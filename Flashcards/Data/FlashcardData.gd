extends Resource
class_name FlashcardData

@export var question: String
@export var answer: String
@export var learned: bool = false
@export var answer_visible: bool = false
@export var last_learned: Dictionary
#@export var files: Array
#@export var interval: int = 1
#@export var repetition: int = 0
#@export var easiness: float = 2.5
#@export var due_date: Time

#func _init(q, a):
	#question = q
	#answer = a
