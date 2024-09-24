extends Resource
class_name UserData

@export var name: String = "Test"
@export var level: int = 1
@export var exp: int = 0
@export var expNeededForNextLevel: int = 350
@export var coins: int = 0
@export var dailyStreak: int = 1
@export var achievements: Array

var expNeededMultiplier = 1.5

func GetDailyStreak():
	return dailyStreak

func SetDailyStreak(val):
	dailyStreak = val

func AddDailyStreak():
	dailyStreak += 1

func SetName(uname):
	name = uname

func SetLevel(lvl):
	level = lvl

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
