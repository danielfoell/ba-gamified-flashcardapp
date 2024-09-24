extends Control

@onready var Achievement = $Panel/MarginContainer/VBoxContainer/Achievement
@onready var Exp = $Panel/MarginContainer/VBoxContainer/Exp

func _ready():
	modulate.a = 0
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	#await tween.finished
	#tween = get_tree().create_tween()
	tween.tween_interval(3)
	tween.tween_property(self, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	queue_free()

func init(achievement):
	Achievement.set_text(GData.data.get("ACHIEVEMENTS")[achievement].get("DESC"))
	Exp.set_text("+" + str(GData.data.get("ACHIEVEMENTS")[achievement].get("EXP")) + " exp")
