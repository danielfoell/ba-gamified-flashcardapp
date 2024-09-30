extends Resource
class_name DeckData

@export var name: String
@export var flashcards: Array[FlashcardData]
#@export learningAlgorithm
@export var isLearning: bool
@export var learningFlashcards: Array[FlashcardData]
@export var color: Color = Color.AQUAMARINE

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

func GetCardCount():
	return flashcards.size()

func SetColor(new_color):
	color = new_color

func GetColor():
	return color
