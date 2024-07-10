extends Panel

@onready var animation_player = $AnimationPlayer
@onready var DeckContainer = $DeckOverviewContainer/HBoxContainer/FolderContainer/DeckContainer
@onready var DeckOverviewContainer = $DeckOverviewContainer

const NEW_DECK = preload("res://Flashcards/CreateNewDeckInterface.tscn")
const DECK = preload("res://Flashcards/DeckInterface.tscn")

func _ready():
	animation_player.play("Open")
	for deck in StorageService.decks:
		var Deck = DECK.instantiate()
		DeckContainer.add_child(Deck)
		Deck.init(deck)
		Deck.DeckSelected.connect(_On_DeckSelected.bind(deck))


func _on_button_pressed():
	queue_free()


func _On_DeckSelected(deck):
	DeckOverviewContainer.hide()

func _On_Btn_New_Folder_Pressed():
	var CreateNewDeck = NEW_DECK.instantiate()
	get_tree().get_root().add_child(CreateNewDeck)
	var Deck = DECK.instantiate()
	await CreateNewDeck.DeckCreated
	DeckContainer.add_child(Deck)
	var deck = StorageService.decks.keys().back()
	Deck.init(deck)
	Deck.DeckSelected.connect(_On_DeckSelected.bind(deck))
