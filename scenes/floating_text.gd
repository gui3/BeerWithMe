extends Node2D

@export var speed: int = 25
@export var timeout: float = 3.5
@export var green_theme: LabelSettings
@export var red_theme: LabelSettings

var alpha: int = 255
var time: float = 0.0
var size_factor: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = timeout
	$Timer.start()
	time = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector2.UP * speed * delta
	time += delta
	modulate.a8 = alpha - alpha * time / timeout
	$Label.scale *= (timeout - (time  - timeout / 8) / 4) / timeout

func set_text_theme(theme: String):
	if theme == "green":
		$Label.label_settings = green_theme
	else:
		$Label.label_settings = red_theme

func set_text(text: String):
	$Label.text = text

func set_size_factor(factor: float):
	$Label.scale = Vector2.ONE * factor

func clamp_to_viewport(screen_size: Vector2):
	var max_viewport = screen_size * 0.9
	var min_viewport = screen_size * 0.1
	position = position.clamp(min_viewport, max_viewport)

func _on_timer_timeout():
	queue_free()
