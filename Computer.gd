extends Control

var bought = false
@onready var coins = $HBoxContainer/Coins
@onready var price = $Panel/MarginContainer/VBoxContainer/GridContainer/Button/Panel/MarginContainer/VBoxContainer/HBoxContainer/Price

func _ready():
	GData.canInteract = false
	coins.set_text(str(GData.user.GetCoins()))
	

func _On_BtnBuy_Pressed():
	if GData.user.GetCoins() >= int(price.text):
		coins.set_text(str(GData.user.GetCoins() - int(price.text)))
		GData.user.SetCoins(0)
		var tween = get_tree().create_tween()
		tween.tween_property($Panel/MarginContainer/VBoxContainer/GridContainer/Button, "custom_minimum_size:x", 0, 1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		tween.parallel().tween_property($Panel/MarginContainer/VBoxContainer/GridContainer/Button/Panel/MarginContainer, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		tween.parallel().tween_property($Panel/MarginContainer/VBoxContainer/GridContainer/Button, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		if bought == false:
			bought = true


func _On_BtnExit_Pressed():
	if bought:
		var room = StorageService.currentRoom
		room.get_node("Cabinet").Unlock()
		StorageService.SaveRoom()
	queue_free()
	GData.canInteract = true
