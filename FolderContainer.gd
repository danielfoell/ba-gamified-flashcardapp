extends VBoxContainer

@onready var FolderContainer = $FolderContainer

func _ready():
	for deck in StorageService.decks:
		pass

func _on_btn_new_folder_pressed():
	pass
	#FolderContainer.add_child(lineEdit)
	#FolderContainer.move_child(lineEdit, 0)
	
