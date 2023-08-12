extends RigidBody2D

signal bar_reached

# Called when the node enters the scene tree for the first time.
func _ready():
	var factor: float = randf() + 0.5
	$CollisionShape2D.scale *= factor
	$Sprite2D.scale *= factor
	$VisibleOnScreenNotifier2D.scale *= factor
	#gravity_scale *= factor


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#func _on_visible_on_screen_notifier_2d_screen_exited():
func reached_bar():
	emit_signal("bar_reached")
	queue_free()
