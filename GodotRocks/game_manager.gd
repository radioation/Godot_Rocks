extends Node

var main_scene = "res://Scenes/Main/main.tscn"
var game_scene = "res://Scenes/Game/game.tscn"
var rock_scene : PackedScene
 

var playarea: Vector2 = Vector2.ZERO
 
var current_level = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playarea = Vector2( 2560, 1600 ) # still bad that I'm hardcoding it
	rock_scene = load("res://Scenes/Rock/rock.tscn")
 
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func reset() -> void:
	current_level = 0
	get_tree().change_scene_to_file(main_scene)
	

func start_next_level() -> int:
	current_level += 1

	
	return current_level
	
func start_game() -> void:
	current_level = 0
	get_tree().change_scene_to_file(game_scene) 
	


	
	#@call_deferred("add_child", rock)
	
