extends CanvasLayer

signal game_started
signal game_ended
signal touch(position: Vector2)
signal release(position: Vector2)

@export var arrow_idle: LabelSettings
@export var arrow_active: LabelSettings


# Called when the node enters the scene tree for the first time.
func _ready():
	$GameControls.hide()
	$MenuControls.show()

func new_game():
	Input.action_release("button_left")
	Input.action_release("button_right")
	set_score(0)
	set_slippery(0.0)

func set_score(score: int):
	#var pints: int = score / 5
	#var tiers: int = score % 5
	#$GameControls/ScoreLabel.set_text(str(pints))
	#$GameControls/TiersVarLabel.set_text(str(tiers))
	$GameControls/ScoreLabel.set_text(str(score))
	$AnimationPlayer.play("score_bump")

func set_slippery(slippery: float):
	# value
	$GameControls/SlipperyLabel.set_text(str(floor(slippery * 100)) + "%")
	# label color
	var r: int = lerp(255, 255, slippery)
	var g: int = lerp(255, 0, slippery)
	var b: int = lerp(255, 0, slippery)
	#
	var label_settings = $GameControls/SlipperyLabel.label_settings
	label_settings.font_color =Color8(r,g,b,255)
	label_settings.outline_size = int(slippery * 20)
	$AnimationPlayer.play("slip_bump")

func end_game(score: int):
	$GameControls.hide()
	Input.action_release("button_left")
	Input.action_release("button_right")

	#var pints: int = score / 5
	#var tiers: int = score % 5
	$MenuControls/BestScoreLabel.set_text(str(score))
	#$MenuControls/TiersVarLabel.set_text(str(tiers))
	#$MenuControls/DropsLabel.set_text(str(score))
	#$MenuControls/MessageBox.set_text("Again ?")
	$MenuControls.show()


func _on_button_menu_pressed():
	$GameControls.show()
	$MenuControls.hide()
	emit_signal("game_started")

func _on_button_stop_pressed():
	emit_signal("game_ended")

func _input(event):
	if event is InputEventScreenTouch || event is InputEventMouseButton:
		if event.pressed:
			Input.action_press("touch")
			if event.position.x < ($ReferenceRect.get_global_rect().size.x / 2):
				Input.action_release("going_right")
				Input.action_press("going_left")
				$GameControls/ButtonRight.label_settings = arrow_idle
				$GameControls/ButtonLeft.label_settings = arrow_active
			else:
				Input.action_release("going_left")
				Input.action_press("going_right")
				$GameControls/ButtonLeft.label_settings = arrow_idle
				$GameControls/ButtonRight.label_settings = arrow_active
		else:
			Input.action_release("touch")
			$GameControls/ButtonLeft.label_settings = arrow_idle
			$GameControls/ButtonRight.label_settings = arrow_idle
	
	elif Input.is_action_pressed("touch") && event is InputEventMouseMotion:
		if event.position.x < ($ReferenceRect.get_global_rect().size.x / 2):
			Input.action_release("going_right")
			Input.action_press("going_left")
			$GameControls/ButtonRight.label_settings = arrow_idle
			$GameControls/ButtonLeft.label_settings = arrow_active
		else:
			Input.action_release("going_left")
			Input.action_press("going_right")
			$GameControls/ButtonLeft.label_settings = arrow_idle
			$GameControls/ButtonRight.label_settings = arrow_active

