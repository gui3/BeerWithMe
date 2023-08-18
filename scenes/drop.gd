extends RigidBody2D

signal bar_reached(drop: Node2D)

var done: bool = false
var weight: float

# Called when the node enters the scene tree for the first time.
func _ready():
	done = false
	var factor: float = randf()
	$CollisionShape2D.scale *= factor + 0.5
	$Sprite2D.scale *= factor + 0.5
	$VisibleOnScreenNotifier2D.scale *= factor + 0.5
	weight = floor(factor * 4.99 + 1) / 100
	#gravity_scale *= factor


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#func _on_visible_on_screen_notifier_2d_screen_exited():
func reach_bar():
	#emit_signal("bar_reached", self)
	queue_free()
