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
	var num_rocks = 10 + current_level * 5
	create_rocks( num_rocks ) 
	
	return current_level
	
func start_game() -> void:
	current_level = 0
	get_tree().change_scene_to_file(game_scene) 
	

	
func create_rocks_in_range( count: int, max_x: int, max_y: int ) -> void:
	for i in count:
		var rot = randf_range(0, TAU)
		
		var vel = Vector2.RIGHT.rotated(rot) * randf_range(1.5,2.7)
		var rando = randi() % 2
		var pos  : Vector2  = Vector2.ZERO
		
		if rando == 0 : 
			pos = Vector2( randi_range( 0.0, max_x ), 0.0 if randi()%2==0 else max_y ) 
			
		else:
			pos = Vector2( 0.0 if randi()%2==0 else max_x , randi_range( 0.0, max_y) )
			
		var rock = rock_scene.instantiate()
		rock.start(pos, vel)
		get_tree().current_scene.add_child( rock )
		
func create_rocks( count: int ) -> void:
	create_rocks_in_range( count, playarea.x, playarea.y) 
	
	#@call_deferred("add_child", rock)
	
