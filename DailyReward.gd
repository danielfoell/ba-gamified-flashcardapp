extends Control

#@onready var DayOne = $Panel/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/HBoxContainer/DayOne/Unlock/AnimatedSprite2D
#@onready var DayTwo = $Panel/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/HBoxContainer/DayTwo/Unlock/AnimatedSprite2D
#@onready var DayOne = $Panel/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/HBoxContainer/DayOne/Unlock/AnimatedSprite2D
#@onready var DayOne = $Panel/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/HBoxContainer/DayOne/Unlock/AnimatedSprite2D
#@onready var DayOne = $Panel/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/HBoxContainer/DayOne/Unlock/AnimatedSprite2D

enum PATH{
	ONE,
	TWO,
	THREE,
	FOUR,
	FIVE
}

var DailyRewards = {
	1: {
		"EXP": 0,
		"COINS": 15,
		"PATH": "Panel/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/HBoxContainer/DayOne/Unlock/"
	},
	2: {
		"EXP": 250,
		"COINS": 0,
		"PATH": "Panel/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/HBoxContainer/DayTwo/Unlock/"
	},
	3: {
		"EXP": 400,
		"COINS": 50,
		"PATH": "Panel/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/HBoxContainer/DayThree/Unlock/"
	},
	4: {
		"EXP": 0,
		"COINS": 30,
		"PATH": "Panel/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/HBoxContainer/DayFour/Unlock/"
	},
	5: {
		"EXP": 1500,
		"COINS": 250,
		"PATH": "Panel/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/HBoxContainer/DayFive/Unlock/"
	}
}

func _ready():
	GSignals.AddedDailyStreak.connect(_On_AddedDailyStreak)

func _On_AddedDailyStreak():
	reparent(get_tree().get_root())
	get_parent().move_child(self, get_parent().get_child_count() - 1)
	show()
	UnlockDay(GData.user.dailyStreak)

func UnlockDay(day):
	for days in day:
		if days > 0:
			var node = get_node(DailyRewards.get(days)["PATH"])
			node.visible = false
	var node = get_node(DailyRewards.get(day)["PATH"] + "AnimatedSprite2D")
	GData.user.AddExp(DailyRewards.get(day)["EXP"])
	GData.user.AddCoins(DailyRewards.get(day)["COINS"])
	node.play("unlock")
	await node.animation_finished
	var tween = get_tree().create_tween()
	tween.tween_property(node, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)


func _On_BtnClose_Pressed():
	hide()
