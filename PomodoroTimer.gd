extends Control

@onready var Status = $VBoxContainer/Status
@onready var TimeLabel = $VBoxContainer/Time
@onready var StartBtn = $VBoxContainer/HBoxContainer/StartBtn
@onready var ResetBtn = $VBoxContainer/HBoxContainer/ResetBtn
@onready var SkipBtn = $VBoxContainer/HBoxContainer/SkipBtn


const WORK_DURATION = 2 #25 minutes
const SHORT_BREAK_DURATION = 5 #5 minutes
const LONG_BREAK_DURATION = 15 #5 minutes

var is_working = true
var pomodoroCounter = 0
var time_left = WORK_DURATION
var timer_started = false
var currentPhase :
	get:
		return currentPhase
	set(phase):
		currentPhase = phase
		match currentPhase:
			PHASES.WORK:
				is_working = true
				Status.text = "Pomodoro"
				time_left = WORK_DURATION
				TimeLabel.text = format_time(WORK_DURATION)
			PHASES.SHORT_BREAK:
				is_working = false
				Status.text = "Kurze Pause"
				time_left = SHORT_BREAK_DURATION
				TimeLabel.text = format_time(SHORT_BREAK_DURATION)
			PHASES.LONG_BREAK:
				is_working = false
				Status.text = "Lange Pause"
				time_left = LONG_BREAK_DURATION
				TimeLabel.text = format_time(LONG_BREAK_DURATION)

enum PHASES {
	WORK = WORK_DURATION,
	SHORT_BREAK = SHORT_BREAK_DURATION,
	LONG_BREAK = LONG_BREAK_DURATION
}

func _ready():
	TimeLabel.text = format_time(time_left)
	currentPhase = PHASES.WORK

func _process(delta):
	if timer_started:
		time_left -= delta
		if time_left <= 0:
			match currentPhase:
				PHASES.WORK:
					if pomodoroCounter == 3:
						pomodoroCounter = 0
						currentPhase = PHASES.LONG_BREAK
					else:
						pomodoroCounter += 1
						currentPhase = PHASES.SHORT_BREAK
				PHASES.SHORT_BREAK:
					currentPhase = PHASES.WORK
				PHASES.LONG_BREAK:
					currentPhase = PHASES.WORK
		TimeLabel.text = format_time(time_left)

func format_time(time):
	var minutes = int(time / 60)
	var seconds = int(time) % 60
	return str(minutes).lpad(2, '0') + ":" + str(seconds).lpad(2, '0')


func _on_start_btn_pressed():
	timer_started = not timer_started
	StartBtn.text = "Pause" if timer_started else "Start"


func _on_reset_btn_pressed():
	timer_started = false
	time_left = PHASES.get(PHASES.keys()[currentPhase])
	TimeLabel.text = format_time(time_left)
	StartBtn.text = "Start"


func _on_skip_btn_pressed():
	timer_started = false
	match currentPhase:
		PHASES.WORK:
			if pomodoroCounter == 3:
				pomodoroCounter = 0
				currentPhase = PHASES.LONG_BREAK
			else:
				pomodoroCounter += 1
				currentPhase = PHASES.SHORT_BREAK
		PHASES.SHORT_BREAK:
			currentPhase = PHASES.WORK
		PHASES.LONG_BREAK:
			currentPhase = PHASES.WORK
