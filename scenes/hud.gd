extends CanvasLayer

signal game_started
signal game_ended


# Called when the node enters the scene tree for the first time.
func _ready():
	$GameControls.hide()
	$MenuControls.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func new_game():
	Input.action_release("button_left")
	Input.action_release("button_right")
	set_score(0)
	set_slippery(0.0)

func set_score(score: int):
	var pints: int = score / 5
	var tiers: int = score % 5
	$GameControls/ScoreLabel.set_text(str(pints))
	$GameControls/TiersVarLabel.set_text(str(tiers))
	$GameControls/DropsLabel.set_text(str(score))

func set_slippery(slippery: float):
	# value
	$GameControls/SlipperyLabel.set_text(str(floor(slippery * 100)) + "%")
	# label color
	var r: int = lerp(0, 255, slippery)
	var g: int = lerp(0, 0, slippery)
	var b: int = lerp(0, 0, slippery)
	#
	var label_settings = $GameControls/SlipperyLabel.label_settings
	label_settings.outline_color =Color8(r,g,b,255)
	label_settings.outline_size = int(slippery * 10)

func end_game(score: int):
	$GameControls.hide()
	Input.action_release("button_left")
	Input.action_release("button_right")

	var pints: int = score / 5
	var tiers: int = score % 5
	$MenuControls/BestScoreLabel.set_text(str(pints))
	$MenuControls/TiersVarLabel.set_text(str(tiers))
	$MenuControls/DropsLabel.set_text(str(score))
	#$MenuControls/MessageBox.set_text("Again ?")
	$MenuControls.show()


func _on_button_menu_pressed():
	$GameControls.show()
	$MenuControls.hide()
	emit_signal("game_started")

# direction buttons
func _on_button_right_button_down():
	Input.action_press("button_right")


func _on_button_right_button_up():
	Input.action_release("button_right")


func _on_button_left_button_down():
	Input.action_press("button_left")


func _on_button_left_button_up():
	Input.action_release("button_left")

func _input(event):
	if Input.is_action_pressed("ui_left"):
		$GameControls/ButtonLeft.set_pressed_no_signal(true)
	elif Input.is_action_pressed("ui_right"):
		$GameControls/ButtonRight.set_pressed_no_signal(true)
	else:
		$GameControls/ButtonLeft.set_pressed_no_signal(false)
		$GameControls/ButtonRight.set_pressed_no_signal(false)


func _on_button_stop_pressed():
	emit_signal("game_ended")
