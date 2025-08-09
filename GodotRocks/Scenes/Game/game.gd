extends Node2D

@export var rock_scene : PackedScene

@export var ufo_scene : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HUD/VBoxContainer/Button.hide()
	$HUD/VBoxContainer/MessageLabel.hide()
	#for i in 20:
		#create_rock()
		#
	#for i in 5:
		#create_ufo()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: 
	if Input.is_action_just_pressed("options"):
		# should we exit back to main screen?
		show_exit_confirmation_dialog()


func create_rock() -> void:
	var vel = Vector2.RIGHT.rotated(randf_range(0, TAU)) * randf_range(1.5,2.7)
	var pos = Vector2( randi_range( 0, 2560), -128 )
	var rock = rock_scene.instantiate()
	rock.start(pos, vel)
	call_deferred("add_child", rock)
	
	
func create_ufo() -> void: 

	var pos = Vector2( randi_range( 0, 2560),randi_range (0, 1600) )
	var u = ufo_scene.instantiate()  
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
		
	# show dialog
	add_child(dialog)	
	dialog.popup_centered() # center on screen
	dialog.show()



func dialog_canceled() -> void:
	print("User clicked Cancel")

func dialog_confirmed() -> void: 
	print("QUIT")
	GameManager.reset()
