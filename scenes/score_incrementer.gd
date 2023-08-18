extends Node2D

signal destination_reached(score: int)

#@export var speed: int = 25
@export var timeout: float = 1.0
@export var destination_node: Node

var alpha: int = 255
var time: float = 0.0
var size_factor: float = 1.0
var destination_score: int

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = timeout
	$Timer.start()
	time = 0
	$AnimationPlayer.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += (destination_node.position - position) * delta / (timeout - time)
	time += delta
	#modulate.a8 = alpha - alpha * time / timeout

func set_destination_score(score: int):
	destination_score = score

func set_text(text: String):
	$Label.text = text

func set_size_factor(factor: float):
	$Label.scale = Vector2.ONE * factor

func set_destination(node: Node):
	destination_node = node

func clamp_to_viewport(screen_size: Vector2):
	var max_viewport = screen_size * 0.9
	var min_viewport = screen_size * 0.1
	position = position.clamp(min_viewport, max_viewport)

func _on_timer_timeout():
	emit_signal("destination_reached", destination_score)
	queue_free()
