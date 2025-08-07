extends Node2D

@export var rock_scene : PackedScene

var screensize = Vector2.ZERO
var rock_start_y = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screensize = get_viewport().get_visible_rect().size

	$RockSpawnTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func create_rock():
	var rock = rock_scene.instantiate()
	add_child(rock)
	rock.position = Vector2( randi_range(0, screensize.x), rock_start_y)
	


func _on_rock_spawn_timer_timeout() -> void:
	create_rock()
