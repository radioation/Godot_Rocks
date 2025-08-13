extends Node2D

@export var rock_scene : PackedScene

var playarea : Vector2 = Vector2.ZERO

func _ready() -> void:
	#playarea = get_viewport().get_visible_rect().size
	playarea = Vector2( 2560, 1600)
	# make rocks
	spawn_rocks(20)
	$Ship.playarea = playarea
	$Ship.position = playarea/2.0
 
	
func spawn_rocks( count : int ) -> void:
	for i in count:
		var r = rock_scene.instantiate()	
		r.playarea = playarea
		r.position = Vector2( randf_range(0, playarea.x), randf_range(0, playarea.y))
		r.linear_velocity = Vector2.RIGHT.rotated(randf_range(0, TAU)) * randf_range( 225.0, 250.0)
		add_child(r)
 
