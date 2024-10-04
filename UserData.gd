extends Resource
class_name UserData

@export var name: String = "Test"
@export var level: int = 1
@export var exp: int = 0
@export var expNeededForNextLevel: int = 350
@export var coins: int = 0
@export var dailyStreak: int = 0
@export var addedDailyStreak: bool = false
@export var learnedLastTime: Dictionary
@export var learnedFirstDeckOfTheDay: bool = false
@export var achievements: Array
@export var tutorialStage: int = TutorialService.TUTORIALSTAGE.START

var expNeededMultiplier = 1.5

func GetDailyStreak():
	return dailyStreak

func SetDailyStreak(val):
	dailyStreak = val

func AddDailyStreak():
	var currentDateTime = Time.get_datetime_dict_from_system()
	var timeDiff = Time.get_unix_time_from_datetime_dict(currentDateTime) - Time.get_unix_time_from_datetime_dict(learnedLastTime)
	if learnedLastTime["day"] != currentDateTime["day"] or learnedLastTime["month"] != currentDateTime["month"] or learnedLastTime["year"] != currentDateTime["year"]:
		if addedDailyStreak == false:
			if timeDiff >= 86000:
				GData.user.SetDailyStreak(0)
			if dailyStreak > 7:
				dailyStreak = 0
			dailyStreak += 1
			addedDailyStreak = true
	elif learnedLastTime["day"] == currentDateTime["day"] or learnedLastTime["month"] == currentDateTime["month"] or learnedLastTime["year"] == currentDateTime["year"]:
		if addedDailyStreak == false:
			if timeDiff >= 86000:
				GData.user.SetDailyStreak(0)
			if dailyStreak > 7:
				dailyStreak = 0
			dailyStreak += 1
			addedDailyStreak = true

func SetName(uname):
	name = uname

func SetLevel(lvl):
	level = lvl
	if level == 2:
		TutorialService.StartStage(TutorialService.TUTORIALSTAGE.FIRSTLEVELUP)

func GetLevel():
	return level

func GetExp():
	return exp

func SetExp(newExp):
	exp = newExp

func AddExp(newExp):
	exp += newExp
	if exp >= expNeededForNextLevel:
		SetLevel(level + 1)
		SetExp(exp - expNeededForNextLevel)
		SetExpNeedForNextLevel()
	StorageService.SaveUser()
	GSignals.ExpChanged.emit()

func GetExpNeededForNextLevel():
	return expNeededForNextLevel

func SetExpNeedForNextLevel():
	expNeededForNextLevel = snappedf(expNeededForNextLevel * expNeededMultiplier, 100)

func UnlockAchievement(achievement):
	achievements.append(achievement)
	AddExp(GData.data.get("ACHIEVEMENTS")[achievement].get("EXP"))
	GSignals.AchievementUnlocked.emit(achievement)
	StorageService.SaveUser()

func HasAchievement(achievement):
	return achievements.has(achievement)
