extends Resource
class_name DeckData

@export var name: String
@export var flashcards: Array[FlashcardData]
#@export learningAlgorithm
@export var isLearning: bool
@export var learningFlashcards: Array[FlashcardData] = flashcards

