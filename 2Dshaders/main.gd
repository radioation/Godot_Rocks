extends Node2D

var current_shade = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	read_input()
	
func read_input() -> void:
	if Input.is_action_just_pressed("ui_accept"):
		current_shade += 1
		$UFO.set_shade( current_shade ) 
	
