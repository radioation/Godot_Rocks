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
		var current_level = GameManager.start_next_level()
		var num_rocks = 10 + current_level * 5
		create_rocks( num_rocks )
	
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
	create_rocks_in_range( count, GameManager.playarea.x, GameManager.playarea.y) 


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

func get_random_ufo_start_position() -> Vector2:
	var rando = randi() % 2
	var pos  : Vector2  = Vector2.ZERO
	
	if rando == 0 : 
		pos = Vector2( randi_range( 0.0, GameManager.playarea.y), 0.0 if randi()%2==0 else GameManager.playarea.y ) 
	else:
		pos = Vector2( 0.0 if randi()%2==0 else GameManager.playarea.y , randi_range( 0.0, GameManager.playarea.y) )

	return pos
	
func _on_ufo_timer_timeout(): 
	$UfoSpawnSound.play()
	if GameManager.current_level % 5 :
		

		var u = ufo_scene.instantiate()  
		u.position = get_random_ufo_start_position()
		 
		#ufo.max_force = 5500
		call_deferred("add_child", u)
	else:
		
		var pos = get_random_ufo_start_position()
		for i in GameManager.current_level: 
			var u = small_ufo_scene.instantiate()  
			u.position = pos + Vector2( randf_range( 10.0, 20.0 ), randf_range( 10.0, 20.0 ))
			 
			#ufo.max_force = 5500
			call_deferred("add_child", u)
			
