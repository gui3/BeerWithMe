extends Area2D

signal drop_collected

@export var speed: int
@export var slippery_factor: float
@export var friction_factor: float


var momentum: float = 0
var screen_size: Vector2
var frame_count: int = 1
var pitch: float
var was_sliding: bool = false

func set_slippery(slippery):
	slippery_factor = slippery

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$SplashInSprite.hide()
	frame_count = $AnimatedSprite2D.sprite_frames.get_frame_count("filling")

func new_game(start_position: Vector2, friction_initial, speed_initial):
	friction_factor = friction_initial
	momentum = 0
	position = start_position
	speed = speed_initial
	set_slippery(0.0)
	pitch = 1.0
	was_sliding = false
	$AnimatedSprite2D.frame = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var going_right =  int((Input.is_action_pressed("touch")\
	 && Input.is_action_pressed("going_right"))\
	 || Input.is_action_pressed("ui_right"))
	var going_left = int((Input.is_action_pressed("touch")\
	 && Input.is_action_pressed("going_left"))\
	 || Input.is_action_pressed("ui_left"))

	# speed
	var acceleration: float = (going_right - going_left)
	#was_sliding && acceleration != 0 && slide()
	#was_sliding = acceleration == 0
	var friction: float = friction_factor - friction_factor * min(0.99, sqrt(slippery_factor))
	momentum += acceleration
	momentum *= (1 - friction)
	
	# bump against walls (reverse momentum)
	var bumped = position.x < 0 || position.x > screen_size.x
	momentum *= 1 - 2 * int(bumped)
	bumped && bump()
	position = position.clamp(Vector2.ZERO, screen_size)
	
	var velocity: Vector2 = Vector2.ZERO
	velocity.x = acceleration + momentum
	position += velocity * speed *  delta

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	add_drop()
	body.queue_free()
	emit_signal("drop_collected")

func play_animation_splash_in():
	$SplashInSprite.show()
	await get_tree().create_timer(0.2).timeout
	$SplashInSprite.hide()

func add_drop():
	var index: int = $AnimatedSprite2D.frame + 1
	index == frame_count && tchin()
	var exponent: float = pow(1.25, index)
	pitch = exponent + randf() * index / frame_count / 2
	index %= frame_count # after pitch for last drop
	$AnimatedSprite2D.frame = index
	$SoundTouk.set_pitch_scale(pitch)
	$SoundTouk.play()
	play_animation_splash_in()

func bump():
	if !$SoundBump.playing:
		$SoundBump.play()

func tchin():
	if !$SoundTchin.playing:
		$SoundTchin.set_pitch_scale(0.8 + randf() * 0.4)
		$SoundTchin.play()

func slide():
	#if !$SoundSlide.playing:
	$SoundSlide.set_pitch_scale(0.9 + randf() * 0.2)
	$SoundSlide.play()
