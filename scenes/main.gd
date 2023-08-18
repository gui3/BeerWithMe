extends Node

@export var drop_scene: PackedScene
@export var slip_incrementer_scene: PackedScene
@export var score_incrementer_scene: PackedScene
@export var friction_initial: float = 0.2
@export var slippery_increment: float = 0.08
@export var speed = 100
@export var spawn_range: float = 1.5
@export var spawn_min: float = 0.5
@export var spawn_min_const: float = 0.2
@export var spawn_score_factor: float = 50

var score: int = 0
var slippery: float = 0.0
var best_score: int = 0
var screen_size: Vector2
var playing: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#resize()
	screen_size = get_viewport().size
	randomize()
	var dict = Global.load_dict()
	print(dict)
	if dict.has("best_score"):
		best_score = dict["best_score"]
	$HUD/MenuControls/BestScoreLabel.set_text(str(best_score))
	$Glass.new_game($Bar/BarCenterMarker.position, friction_initial, speed)
	$MusicGingle64.play()

func resize():
	var v_size = get_viewport().size
	var scale_x = v_size.x / $GameSizeRect.get_size().x
	var scale_y = v_size.y / $GameSizeRect.get_size().y
	

func new_game():
	score = 0
	slippery = 0.0
	$Glass.new_game($Bar/BarCenterMarker.position, friction_initial, speed)
	$Bar.new_game()
	$HUD.new_game()
	$DropSpawnTimer.start()
	set_music_speed(1.0)
	$MusicGingle64.stop()
	$MusicDragtime.play()
	playing = true

func set_music_speed(factor: float):
	$MusicDragtime.pitch_scale = factor
	AudioServer.get_bus_effect(
		AudioServer.get_bus_index("pitch_deshifter"),
		0
	).pitch_scale = 1.0/factor

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_drop_spawn_timer_timeout():
	var location = $DropPath/DropSpawnLocation
	location.set_progress_ratio(randf())
	var drop = drop_scene.instantiate()
	drop.position = location.position
	#drop.bar_reached.connect(_on_drop_bar_reached)
	add_child(drop)
	
	var spawn_factor: float = (spawn_score_factor + float(score)) / spawn_score_factor
	
	$DropSpawnTimer.set_wait_time(spawn_min_const \
	+ (randf() * spawn_range + spawn_min) / spawn_factor)


func _on_glass_drop_collected(drop: Node2D):
	if playing && not drop.done:
		score += 1
		drop.done = true
		var text = score_incrementer_scene.instantiate()
		text.position.x = $Glass.position.x 
		text.position.y = $Glass.position.y - 120
		text.clamp_to_viewport(screen_size)
		text.set_text("+1")
		text.set_destination($HUD/GameControls/ScoreDestination)
		text.set_destination_score(score)
		text.destination_reached.connect(set_score)
		add_child(text)

func set_score(score: int):
	$HUD.set_score(score)

func end_game():
	playing = false
	best_score = max(best_score, score)
	Global.save_dict({"best_score": best_score})
	$DropSpawnTimer.stop()
	$MusicDragtime.stop()
	$HUD.end_game(score, best_score)
	$MusicGingle64.play()
	

func _on_bar_bar_reached(drop: Node2D):
	if playing && not drop.done:
		drop.done = true
		drop.reach_bar()
		var weight: float = drop.weight
		slippery += weight
		slippery = min(0.9991, slippery)
		$Bar.set_slippery(slippery)
		$HUD.set_slippery(slippery)
		$Glass.set_slippery(slippery)
		set_music_speed(1.0 + slippery / 2)
		
		var text = slip_incrementer_scene.instantiate()
		text.position = drop.position
		text.clamp_to_viewport(screen_size)
		text.set_text(str(floor(weight * 100)) + "%")
		text.set_size_factor(0.5 + weight * 20)
		add_child(text)
		
		if slippery >= 0.999:
			end_game()


func _on_hud_game_ended():
	end_game()


func _on_hud_game_started():
	new_game()

func _unhandled_input(event):
	if event is InputEventScreenTouch\
	|| event is InputEventMouseButton:
		touching(event.pressed)
		dragging(event.position)
	elif event is InputEventMouseMotion:
		dragging(event.position)

func touching(pressed: bool):
	if (pressed):
		Input.action_press("touch")
	else:
		Input.action_release("touch")

func dragging(position: Vector2):
	if Input.is_action_pressed("touch"):
		$Glass.set_touch_position(position)


func _on_glass_dragging(direction: int):
	$HUD.going_right(direction > 0)
	$HUD.going_left(direction < 0)

