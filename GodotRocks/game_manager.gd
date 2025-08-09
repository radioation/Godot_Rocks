extends Node

var main_scene = "res://Scenes/Main/main.tscn"
var game_scene = "res://Scenes/Game/game.tscn"

var playarea: Vector2 = Vector2.ZERO

var current_level = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playarea = Vector2( 2560, 1600 ) # still bad that I'm hardcoding it


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func reset() -> void:
	current_level = 0
	get_tree().change_scene_to_file(main_scene)
	
	

func start_game() -> void:
	current_level = 0
	get_tree().change_scene_to_file(game_scene)

	
