extends Node

var user: UserData = UserData.new()
var file = FileAccess.open("res://Data/Data.json", FileAccess.READ)
var data = JSON.parse_string(file.get_as_text())

enum EXP{
	CARD_SOLVED,
	DECK_FIRSTTRY,
	DECK_COMPLETED,
	DECK_FIRSTOFTHEDAY,
}

enum ACHIEVEMENTS{
	CREATED_FIRSTCARD,
	CREATED_TENCARDS,
	CREATED_FIRSTDECK
}
