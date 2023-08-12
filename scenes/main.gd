extends Node

@export var drop_scene: PackedScene
@export var friction_initial: float = 0.5
@export var slippery_increment: float = 0.05
@export var speed = 200
@export var spawn_range: float = 1.5
@export var spawn_min: float = 0.5
@export var spawn_min_const: float = 0.2
@export var spawn_score_factor: float = 50

var score: int = 0
var slippery: float = 0.0
var best_score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#resize()
	randomize()
	$Glass.new_game($Bar/BarCenterMarker.position, friction_initial, speed)

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


func _on_glass_drop_collected():
	score += 1
	$HUD.set_score(score)

func end_game():
	best_score = max(best_score, score)
	$DropSpawnTimer.stop()
	$HUD.end_game(best_score)

func _on_bar_bar_reached():
	slippery += slippery_increment - slippery_increment * slippery
	$Bar.set_slippery(slippery)
	$HUD.set_slippery(slippery)
	$Glass.set_slippery(slippery)
	if slippery >= 0.99:
		end_game()


func _on_hud_game_ended():
	end_game()


func _on_hud_game_started():
	new_game()
