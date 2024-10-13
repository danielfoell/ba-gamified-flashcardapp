extends Control

var bought = false

func _On_BtnBuy_Pressed():
	if bought == false:
		bought = true


func _On_BtnExit_Pressed():
	if bought:
		var room = StorageService.currentRoom
		room.get_node("Cabinet").Unlock()
		StorageService.SaveRoom()
	queue_free()
