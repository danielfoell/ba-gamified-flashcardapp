extends Node

#var save_path = "user://flashcards.cards"
var base_save_path = "user://Decks/"
var deck_save_path = "user://Decks/%s.deck"
var user_save_path = "user://User/user.ud"
var base_user_save_path = "user://User/"

var flashcards: Array = []
#var decks: Dictionary = {}

var decks: Array[DeckData]

var currentDeck

func _ready():
	LoadUser()
	LoadFlashcards()

func LoadUser():
	if not DirAccess.dir_exists_absolute(base_user_save_path): return
	var dir = DirAccess.open(base_user_save_path)
	var file = FileAccess.open(user_save_path, FileAccess.READ)
	if file:
		var userData: UserData = UserData.new()
		var data = file.get_var()
		userData.name = data.name
		userData.level = data.level
		userData.exp = data.exp
		userData.expNeededForNextLevel = data.expNeededForNextLevel
		userData.coins = data.coins
		userData.dailyStreak = data.dailyStreak
		userData.achievements = data.achievements
		GData.user = userData
		print("XD ", GData.user.exp)
		print("User loaded")
	else:
		print("Failed loading user")

func SaveUser():
	if not DirAccess.dir_exists_absolute(base_user_save_path):
		DirAccess.make_dir_absolute(base_user_save_path)
	var userData: UserData = GData.user
	var userConverted: Dictionary
	userConverted = {
		"name": userData.name,
		"level": userData.level,
		"exp": userData.exp,
		"expNeededForNextLevel": userData.expNeededForNextLevel,
		"coins": userData.coins,
		"dailyStreak": userData.dailyStreak,
		"achievements": userData.achievements
	}
	var file = FileAccess.open(user_save_path, FileAccess.WRITE)
	if file:
		file.store_var(userConverted)
		file.close()
		#print("Saved")
	else:
		pass
		#print("Failed saving")

func LoadFlashcards():
	if not DirAccess.dir_exists_absolute(base_save_path): return
	var dir = DirAccess.open(base_save_path)
	for deck in dir.get_files():
		var file = FileAccess.open(deck_save_path % deck.get_basename(), FileAccess.READ)
		if file:
			var newDeck = DeckData.new()
			newDeck.name = deck.get_basename()
			var flashcards = file.get_var()
			for flashcard in flashcards:
				var newFlashcard = FlashcardData.new()
				newFlashcard.question = flashcard["question"]
				newFlashcard.answer = flashcard["answer"]
				newFlashcard.answer_visible = flashcard["answer_visible"]
				newFlashcard.learned = flashcard["learned"]
				newFlashcard.last_learned = flashcard["last_learned"]
				newDeck.flashcards.append(newFlashcard)
				if newFlashcard.learned == false:
					newDeck.learningFlashcards.append(newFlashcard)
			decks.append(newDeck)
			file.close
			#print("Loaded")
		else:
			pass
			#print("Failed loading")

func SaveFlashcards():
	if not DirAccess.dir_exists_absolute(base_save_path):
		DirAccess.make_dir_absolute(base_save_path)
	for deck in decks:
		var flashcards = deck.flashcards
		var flashcardsConverted: Array
		for flashcard in flashcards:
			flashcardsConverted.append({
				"question": flashcard.question,
				"answer": flashcard.answer,
				"answer_visible": flashcard.answer_visible,
				"learned": flashcard.learned,
				"last_learned": flashcard.last_learned
			})
		var file = FileAccess.open(deck_save_path % deck.name, FileAccess.WRITE)
		if file:
			file.store_var(flashcardsConverted)
			file.close()
			#print("Saved")
		else:
			pass
			#print("Failed saving")

func DeleteDeck(deck: DeckData):
	DirAccess.remove_absolute(deck_save_path % deck.name)
