extends Node2D

@export var rock_scene : PackedScene
 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var screensize = get_viewport().get_visible_rect().size
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
		rock.start(pos, vel)
		call_deferred("add_child", rock)
	
 
