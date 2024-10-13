extends Control

@onready var Unlock = $Panel/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/HBoxContainer/DayOne/Unlock/AnimatedSprite2D
var DailyRewards = {
	"ONE": {
		"EXP": 0,
		"COINS": 15
	},
	"TWO": {
		"EXP": 250,
		"COINS": 0
	},
	"THREE": {
		"EXP": 400,
		"COINS": 50
	},
	"FOUR": {
		"EXP": 0,
		"COINS": 30
	},
	"FIVE": {
		"EXP": 1500,
		"COINS": 250
	}
}

func _ready():
	Unlock.play("unlock")
	await Unlock.animation_finished
	var tween = get_tree().create_tween()
	tween.tween_property(Unlock, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
