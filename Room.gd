extends Node3D

@onready var AnimPlayer = $AnimationPlayer
@onready var Computer = $Computer


func _ready():
	if GData.user.tutorialStage == TutorialService.TUTORIALSTAGE.START:
		$Background.no_depth_test = true

