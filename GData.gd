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

func _ready():
	#CheckIfDayPassed
	var learnedLastTime = GData.user.learnedLastTime
	var currentDateTime = Time.get_datetime_dict_from_system()
	if !learnedLastTime.is_empty():
		if learnedLastTime["day"] != currentDateTime["day"] or learnedLastTime["month"] != currentDateTime["month"] or learnedLastTime["year"] != currentDateTime["year"]:
			GData.user.addedDailyStreak = false
			var timeDiff = Time.get_unix_time_from_datetime_dict(currentDateTime) - Time.get_unix_time_from_datetime_dict(learnedLastTime)
			if timeDiff >= 86000:
				GData.user.SetDailyStreak(0)
				StorageService.SaveUser()
