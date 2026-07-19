extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not OS.has_feature("mobile"):
		$VirtualJoystick.hide()
		$VirtualJoystick2.hide()
		$Control/TouchScreenButton.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func set_score(new_score: int) -> void:
	$MarginContainer/HBoxContainer/ScoreLabel.text = "SCORE: " + str ( new_score )
	
	
func set_lives(new_lives: int) -> void:
	$MarginContainer/HBoxContainer/LivesLabel.text = "LIVES: " + str ( new_lives )
	
func set_message( msg: String ) -> void:
	$VBoxContainer/MessageLabel.text = msg
	


func _on_button_pressed() -> void:
	var ev_down = InputEventAction.new()
	ev_down.action = "start"
	ev_down.pressed = true
	Input.parse_input_event(ev_down)
	
	#var ev_up = InputEventAction.new()
	#ev_up.action = "start"
	#ev_up.pressed = false
	#Input.parse_input_event(ev_up)
