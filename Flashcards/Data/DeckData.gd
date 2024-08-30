extends Resource
class_name DeckData

@export var name: String
@export var flashcards: Array[FlashcardData]
#@export learningAlgorithm
@export var isLearning: bool
@export var learningFlashcards: Array[FlashcardData] = flashcards

func AllCardsLearned() -> bool :
	return true if learningFlashcards.is_empty() and !flashcards.is_empty() and flashcards.front().learned == true else false

func GetLearnedFlashcards():
	return flashcards.filter(func(card):
		return card.learned)

func GetName():
	return name

func GetFlashcards():
	return flashcards

func GetLearningFlashcards():
	return learningFlashcards
