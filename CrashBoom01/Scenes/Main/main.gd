extends Node2D

@export var rock_scene : PackedScene
@export var explosion_scene : PackedScene

var screensize = Vector2.ZERO
var rock_start_y : float = 0
var lives : int = 5
var score : int = 0

var playing :bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screensize = get_viewport().get_visible_rect().size
	start_game()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func create_rock():
	var rock = rock_scene.instantiate()
	add_child(rock)
	rock.position = Vector2( randi_range(0, screensize.x), rock_start_y)
	


func _on_rock_spawn_timer_timeout() -> void:
	create_rock()


func _on_player_hit() -> void:
	var explo = explosion_scene.instantiate()
	explo.position = $Player.position
	add_child(explo)
	$ExplosionSound.play()
	$Player.hide()
	
	lives -= 1
	print("Lives: " + str(lives))


	
func reset_game() -> void:
	# reset lives and score
	lives = 3  
	score = 0 
	
	# place the 
	$Player.reset(  Vector2( screensize.x/ 2, screensize.y - $Player/Sprite2D.texture.get_size().y) )
	
	
func start_game() -> void:
	reset_game()
	playing = true
	$RockSpawnTimer.start()
	$ScoreTimer.start()




func _on_score_timer_timeout() -> void:
	score += 10 
	print("Score: " + str(score))
	 
	
	
