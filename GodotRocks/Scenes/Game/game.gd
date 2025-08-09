extends Node2D

@export var rock_scene : PackedScene
@export var ufo_scene : PackedScene
@export var small_ufo_scene : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HUD/VBoxContainer/Button.hide()
	$HUD/VBoxContainer/MessageLabel.hide()
	
	

		#$UfoTimer.start( randf_range( ,20 ) )
	
	#for i in 20:
		#create_rock()
		##
	#for i in 5:
		#create_ufo()
	#for i in  15:
		#create_small_ufo()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: 
	if Input.is_action_just_pressed("options"):
		# should we exit back to main screen?
		show_exit_confirmation_dialog()

	if get_tree().get_nodes_in_group("rocks").size() == 0:
		GameManager.start_next_level()
		
	
	if $UfoTimer.is_stopped() and get_tree().get_nodes_in_group("ufos").size() == 0:
		$UfoTimer.start( randf_range( 10.0, 30))
 
	
	
func create_ufo() -> void: 

	var pos = Vector2( randi_range( 0, 2560),randi_range (0, 1600) )
	var u = ufo_scene.instantiate()  
	u.position = pos
	 
	#ufo.max_force = 5500
	call_deferred("add_child", u)

	
func create_small_ufo() -> void: 

	var pos = Vector2( randi_range( 0, 2560),randi_range (0, 1600) )
	var u = small_ufo_scene.instantiate()  
	u.position = pos
	 
	#ufo.max_force = 5500
	call_deferred("add_child", u)


func show_exit_confirmation_dialog():
	# Create dialog
	var dialog = ConfirmationDialog.new() 
	dialog.title = "Quit Game" 
	dialog.dialog_text = "Exit to Main?"

	# connect signals
	dialog.canceled.connect (dialog_canceled)
	dialog.confirmed.connect (dialog_confirmed)
	dialog.process_mode = Node.PROCESS_MODE_ALWAYS
	# show dialog
	get_tree().paused = true
	add_child(dialog)	
	dialog.popup_centered() # center on screen
	dialog.show()



func dialog_canceled() -> void:
	print("User clicked Cancel")
	get_tree().paused = false

func dialog_confirmed() -> void: 
	print("QUIT")
	get_tree().paused = false
	GameManager.reset()


func _on_ufo_timer_timeout():
	print("SPAWN A UFO" )
	if GameManager.current_level % 5 :
		var pos = Vector2( randi_range( 0, 2560),randi_range (0, 1600) )
		var u = ufo_scene.instantiate()  
		u.position = pos
		 
		#ufo.max_force = 5500
		call_deferred("add_child", u)
	else:
		for i in GameManager.current_level:
			var pos = Vector2( randi_range( 0, 2560),randi_range (0, 1600) )
			var u = small_ufo_scene.instantiate()  
			u.position = pos
			 
			#ufo.max_force = 5500
			call_deferred("add_child", u)
			
