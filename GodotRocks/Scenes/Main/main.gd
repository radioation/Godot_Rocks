extends Node2D

@export var rock_scene : PackedScene
 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var screensize = get_viewport().get_visible_rect().size
	GameManager.create_rocks_in_range(100, screensize.x, screensize.y)
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: 
	if Input.is_action_just_pressed("options"):
		print("QUIT")
		get_tree().quit()
	if Input.is_action_just_pressed("start"):
		print("start")
		GameManager.start_game()


#func create_rock() -> void:
	#var vel = Vector2.RIGHT.rotated(randf_range(0, TAU)) * randf_range(1.5,2.7)
	#var pos = Vector2( randi_range( 0, 2560), -128 )
	#var rock = rock_scene.instantiate()
	#rock.start(pos, vel)
	#call_deferred("add_child", rock)
	
 
