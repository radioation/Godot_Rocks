extends Node2D

@export var rock_scene : PackedScene
 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var screensize = get_viewport().get_visible_rect().size
		# Get the root Viewport
	var main_viewport = get_tree().root.get_viewport()

	# Disable rendering of Layer 2 in the main view
	if main_viewport.canvas_cull_mask & 2:
		main_viewport.canvas_cull_mask = main_viewport.canvas_cull_mask - 2 # -2 for Layer 2, 
	
	create_rocks(100, screensize.x, screensize.y)
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: 
	if Input.is_action_just_pressed("options"):
		print("QUIT")
		get_tree().quit()
	if Input.is_action_just_pressed("start"):
		print("start")
		GameManager.start_game()


func create_rocks(count: int, max_x: int, max_y: int ) -> void:
	for i in count:
		var vel = Vector2.RIGHT.rotated(randf_range(0, TAU)) * randf_range(1.5,2.7)
		var pos = Vector2( randi_range( 0, max_x), randi_range( 0, max_y) )
		var rock = rock_scene.instantiate()
		rock.start(randi_range(1,3), pos, vel)
		rock.visibility_layer = rock.visibility_layer + 2
		call_deferred("add_child", rock)
	
 
