extends Area2D

signal bar_reached(position: Vector2)

@export var beer_spilled_max_scale: float = 0.35

# Called when the node enters the scene tree for the first time.
func _ready():
	$BeerSpilledSprite.position = $BarCenterMarker.position
	$SplashOutSprite.position = $BarCenterMarker.position
	$SplashOutSprite.hide()
	$BeerSpilledSprite.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func new_game():
	$BeerSpilledSprite.set_scale(Vector2.ONE * 0.1)
	$BeerSpilledSprite.hide()

func set_slippery(percent: float):
	$BeerSpilledSprite.show()
	$BeerSpilledSprite.set_scale(Vector2.ONE * percent * beer_spilled_max_scale)


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	emit_signal("bar_reached", body)
	body.queue_free()
	play_animation_splash_out(body)

func play_animation_splash_out(body: Node2D):
	#$SplashOutSprite.set_scale(Vector2.ONE * (randf() * 0.4 + 0.1))
	$SplashOutSprite.position.x = body.position.x
	$SplashOutSprite.show()
	var pitch: float = 1.2 + (1 - body.weight * 20) * 0.4
	$SplashSound.set_pitch_scale(pitch)
	$SplashSound.play()
	await get_tree().create_timer(0.3).timeout
	$SplashOutSprite.hide()

