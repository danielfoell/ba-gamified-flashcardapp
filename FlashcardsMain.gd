extends Panel

@onready var animation_player = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("Open")
	#animation_player.queue("Tumbleweed")

func _on_button_pressed():
	queue_free()
