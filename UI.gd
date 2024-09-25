extends MarginContainer

@onready var Level = $Exp/HBoxContainer/Level
@onready var ExpBar = $Exp/HBoxContainer/ExpBar
@onready var ExpValue = $Exp/HBoxContainer/ExpBar/MarginContainer/ExpValue
@onready var ExpProgress = $Exp/HBoxContainer/Control/ExpProgress
@onready var AudioPlayer = $"../AudioStreamPlayer"


const NEW_ACHIEVEMENT_VIEW = preload("res://NewAchievementView.tscn")
var curLevel

func _ready():
	GSignals.ExpChanged.connect(_RefreshProgress)
	GSignals.AchievementUnlocked.connect(_AchievementUnlocked)
	curLevel = GData.user.level
	Level.set_text("Lv. " + str(GData.user.level))
	ExpValue.set_text(str(GData.user.exp) + "/" + str(GData.user.expNeededForNextLevel))
	ExpProgress.set_max(GData.user.expNeededForNextLevel)
	ExpProgress.set_value(GData.user.exp)
	ExpBar.set_max(GData.user.expNeededForNextLevel)
	ExpBar.set_value(GData.user.exp)

func _AchievementUnlocked(achievement):
	var achievementView = NEW_ACHIEVEMENT_VIEW.instantiate()
	add_child(achievementView)
	achievementView.init(achievement)

func _RefreshProgress():
	var tween = get_tree().create_tween()
	if curLevel < GData.user.level:
		curLevel = GData.user.level
		tween.tween_property(ExpProgress, "value", ExpProgress.max_value, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		await tween.finished
		tween = get_tree().create_tween()
		AudioPlayer.play()
		tween.tween_property(ExpProgress, "scale", Vector2(0.2, 0.2), 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(ExpProgress, "scale", Vector2(0.165, 0.165), 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		await tween.finished
		tween = get_tree().create_tween()
		ExpProgress.set_value(0)
		ExpProgress.set_max(GData.user.expNeededForNextLevel)
	Level.set_text("Lv. " + str(GData.user.level))
	ExpValue.set_text(str(GData.user.exp) + "/" + str(GData.user.expNeededForNextLevel))
	tween.tween_property(ExpProgress, "value", GData.user.exp, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
