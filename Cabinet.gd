extends Node3D

@onready var AnimPlayer = $AnimationPlayer

func _ready():
	AnimPlayer.play("RESET")

func Unlock():
	AnimPlayer.play("Unlock")
