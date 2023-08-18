extends CanvasLayer

signal game_started
signal game_ended
signal touch(position: Vector2)
signal release(position: Vector2)

@export var arrow_idle: LabelSettings
@export var arrow_active: LabelSettings

var displayed_score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$GameControls.hide()
	$MenuControls/ScoreLabel.hide()
	$MenuControls/ScoreLogo.hide()
	$MenuItemAnimation.play("active")
	$MenuControls.show()

func new_game():
	$MenuItemAnimation.stop()
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
	$ScoreAnimation.play("score_bump")

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
	$SlipAnimation.play("slip_bump")

func end_game(score: int, best_score: int):
	$GameControls.hide()

	$MenuItemAnimation.play("active")
	$MenuControls/ScoreLabel.show()
	$MenuControls/ScoreLogo.show()

	#var pints: int = score / 5
	#var tiers: int = score % 5
	$MenuControls/ScoreLabel.set_text(str(score))
	$MenuControls/BestScoreLabel.set_text(str(best_score))
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

func going_left(pressed: bool = true):
	if pressed:
		$GameControls/ButtonLeft.label_settings = arrow_active
	else:
		$GameControls/ButtonLeft.label_settings = arrow_idle

func going_right(pressed: bool = true):
	if pressed:
		$GameControls/ButtonRight.label_settings = arrow_active
	else:
		$GameControls/ButtonRight.label_settings = arrow_idle


func _on_menu_item_animation_animation_finished(anim_name):
	$MenuItemAnimation.play(anim_name)
