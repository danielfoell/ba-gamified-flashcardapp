extends Node3D

@onready var AnimPlayer = $AnimationPlayer

func _ready():
	if GData.user.tutorialStage == 0:
		$Background.no_depth_test = true

func Setup():
	$Background.no_depth_test = false
	AnimPlayer.play("FIRSTBUILDUP")
