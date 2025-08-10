extends Node2D

@export var rock_scene : PackedScene
@export var ufo_scene : PackedScene
@export var small_ufo_scene : PackedScene


var playing : bool = false
var score : int = 0
var lives : int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HUD/VBoxContainer/Button.hide()
	$HUD/VBoxContainer/MessageLabel.hide()
	start_game()
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
	if not playing:
		return
	if get_tree().get_nodes_in_group("rocks").size() == 0:
		var current_level = GameManager.start_next_level()
		var num_rocks = 2 + current_level * 2
		
		create_rocks( num_rocks, 3 )
	
	if $UfoTimer.is_stopped() and get_tree().get_nodes_in_group("ufos").size() == 0:
		$UfoTimer.start( randf_range( 10.0, 30))
 
	

func start_game() ->void:
	# cleanup if necessary
	get_tree().call_group("rocks", "queue_free") 
	get_tree().call_group("ufos", "queue_free") 
	score = 0
	$HUD.set_score(score)
	lives = 3
	$HUD.set_lives(lives)
	playing = true

	
func create_rock_in_range(  size: int, max_x: int, max_y: int ) -> void: 
	var rot = randf_range(0, TAU)
	
	var rando = randi() % 2
	var pos  : Vector2  = Vector2.ZERO
	
	if rando == 0 : 
		pos = Vector2( randi_range( 0.0, max_x ), 0.0 if randi()%2==0 else max_y ) 
		
	else:
		pos = Vector2( 0.0 if randi()%2==0 else max_x , randi_range( 0.0, max_y) )
	
	var vel = Vector2.RIGHT.rotated(rot) * randf_range(1.5,2.7)
	create_rock( size, pos, vel )
	
		
func create_rock( size, pos: Vector2, vel: Vector2):
	var rock = rock_scene.instantiate()
	rock.start(size, pos, vel)
	get_tree().current_scene.add_child( rock )
	rock.destroyed.connect( self._on_rock_destroyed )
		
func create_rocks( count: int, size: int ) -> void:
	for i in count:
		create_rock_in_range( size, GameManager.playarea.x, GameManager.playarea.y) 

func _on_rock_destroyed( size, radius, pos, vel ):
	if size <= 1:  # small already, don't spawn more
		return
	for i  in  2:
		var rot = randf_range(0, TAU)
		var dir = Vector2.RIGHT.rotated(rot)
		var newpos = pos + dir * radius
		var newvel = dir * vel.length() * 1.2
		create_rock( size -1, newpos, newvel)
	score = score + 200 - (size * 50 )
	$HUD.set_score(score)
		
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
		pos = Vector2( randi_range( 0.0, GameManager.playarea.x), 0.0 if randi()%2==0 else GameManager.playarea.y ) 
	else:
		pos = Vector2( 0.0 if randi()%2==0 else GameManager.playarea.x , randi_range( 0.0, GameManager.playarea.y) )

	return pos
	
func _on_ufo_timer_timeout(): 
	
	$UfoTimer.stop()
	$UfoSpawnSound.play()
	if GameManager.current_level % 5 :
		

		var u = ufo_scene.instantiate()  
		u.position = get_random_ufo_start_position()
		u.destroyed.connect( self._on_ufo_destroyed )
		#ufo.max_force = 5500
		call_deferred("add_child", u)
	else:
		
		var pos = get_random_ufo_start_position()
		for i in GameManager.current_level: 
			var u = small_ufo_scene.instantiate()  
			u.position = pos + Vector2( randf_range( 10.0, 20.0 ), randf_range( 10.0, 20.0 ))
			
			u.destroyed.connect( self._on_ufo_destroyed )
			call_deferred("add_child", u)
			

func _on_ufo_destroyed(value: int):
	score = score + value
	$HUD.set_score( score )
	


func _on_player_hit_points_changed() -> void:
	pass # TODO: add a health bar someday


func _on_player_death() -> void:
	print("PLAYER DEATH")
	lives = lives -1 
	if lives <= 0 :
		game_over()
	$HUD.set_lives(lives)
	$RespawnTimer.start(5)
	
	
	
func game_over() -> void:
	# wait a bit 
	playing = false
	$HUD.set_message("GAME OVER")
	$Timer.start(3)
	await $Timer.timeout
	GameManager.reset()


func _on_respawn_timer_timeout() -> void:
	print("RESPAWN TIMEOUT")
	$Player.respawn()
	$RespawnTimer.stop()
	
