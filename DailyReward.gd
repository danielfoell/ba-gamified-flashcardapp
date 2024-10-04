extends Control

@onready var Unlock = $Panel/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/HBoxContainer/DayOne/Unlock/AnimatedSprite2D

func _ready():
	Unlock.play("unlock")
	await Unlock.animation_finished
	var tween = get_tree().create_tween()
	tween.tween_property(Unlock, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
