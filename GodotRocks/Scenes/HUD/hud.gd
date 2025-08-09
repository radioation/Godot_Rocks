extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func update_score(new_score: int) -> void:
	$MarginContainer/HBoxContainer/Score.text = "SCORE: " + str ( new_score )
	
	
func update_lives(new_lives: int) -> void:
	$MarginContainer/HBoxContainer/Lives.text = "LIVES: " + str ( new_lives )
	
func set_message( msg: String ) -> void:
	$MarginContainer/MessageLabel.text = msg
