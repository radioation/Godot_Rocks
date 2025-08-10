extends Area2D

# signals  
signal hit_points_changed
signal death

@export var green_shot_scene : PackedScene
@export var blue_shot_scene : PackedScene

var can_shoot = true
var can_shoot_secondary = true 

enum { INIT, ALIVE, INVUL, DEAD }
var curr_state = INIT



@export var max_speed : float = 900.0
@export var acceleration : float = 450.0
@export var rotation_speed : float = 5.0
@export var drag = 0.975


var thrust : float = 0.0
var velocity := Vector2.ZERO

var rotation_dir :float = 0.0

var shot_dir = Vector2.ZERO
var secondary_shot_dir = Vector2.ZERO
var half_screen = Vector2.ZERO
var radius :float = 0.0


@export var max_hit_points = 10
var hit_points = 0 # : set = set_hit_points 

# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	hit_points = max_hit_points
	position = GameManager.playarea / 2.0
	set_state( ALIVE )
	#$ShotCooldownTimer.wait_time = 0;
	radius = $CollisionShape2D.shape.radius
	half_screen = get_viewport().size / 2.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	read_input()



func set_state( new_state ) -> void:
	match new_state:
		INIT: 
			$CollisionShape2D.set_deferred("disabled", true)
			$Sprite2D.modulate.a = 0.5
		ALIVE: 
			$CollisionShape2D.set_deferred("disabled", false)
			$Sprite2D.modulate.a =1.0
		INVUL: 
			$CollisionShape2D.set_deferred("disabled", true)
			$Sprite2D.modulate.a = 0.5
		DEAD: 
			$CollisionShape2D.set_deferred("disabled", true)
			$Sprite2D.hide() 
			velocity = Vector2.ZERO
			$ThrustSound.stop() 
	curr_state = new_state


func _physics_process(delta: float) -> void:
	#constant_force = thrust
	rotation += rotation_dir * rotation_speed * delta
	
	if thrust > 0.0 :
		if $ThrustSound.playing == false:
			$ThrustSound.play() 
		var thrust_vector = Vector2( cos(rotation), sin(rotation)).normalized()
		velocity += thrust_vector * thrust * delta
		if velocity.length() > max_speed:
			velocity = velocity.normalized() * max_speed
	#else:
	# work in the opposite directoy of velocity
	var dv = velocity * -0.012
	velocity += dv
		
	#print("VELOCITY: " + str(velocity) )
	position += velocity * delta
	
	if position.x < 0:
		position.x = 0
		velocity.x = 0
	elif position.x > GameManager.playarea.x:
		position.x = GameManager.playarea.x
		velocity.x = 0
	if position.y < 0:
		position.y = 0
		velocity.y = 0
	elif position.y > GameManager.playarea.y:
		position.y = GameManager.playarea.y
		velocity.y = 0 
	
	
func read_input() -> void:
	thrust = 0.0
	if curr_state in [ INIT, DEAD ]:
		return
	if Input.is_action_pressed("thrust"):
		thrust = acceleration * Input.get_action_strength("thrust")
	else:
		$ThrustSound.stop() 
			
		
	rotation_dir = Input.get_axis("left", "right")
	
	
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()
	
	if Input.is_action_pressed("shoot_2nd") and can_shoot_secondary:
		var cam = get_viewport().get_camera_2d(); 
		var mp = get_viewport().get_mouse_position()
		var rel_mp = mp + cam.get_screen_center_position() - half_screen
 
		secondary_shot_dir = rel_mp - get_global_transform().origin
	else:
		secondary_shot_dir = Input.get_vector("left_2nd", "right_2nd", "up_2nd", "down_2nd")
		
	if secondary_shot_dir.length() > 0.2 and can_shoot_secondary:
		shoot_secondary()
 

 
		

func shoot() -> void:
	can_shoot = false
	var shot = green_shot_scene.instantiate()
	get_tree().root.add_child(shot)
	var f_rate = shot.start( $BarrelMarker.global_transform)

	$ShotCooldownTimer.wait_time = f_rate
	$ShotCooldownTimer.start()
		
func shoot_secondary() -> void:
	can_shoot_secondary = false
	var shot = blue_shot_scene.instantiate()
	get_tree().root.add_child(shot) 
	var gt = global_transform
	gt.x = secondary_shot_dir.normalized()
	gt.y =  gt.x.rotated(1.5708)
	var f_rate = shot.start( gt )
	
	$SecondaryShotCooldownTimer.wait_time = f_rate
	$SecondaryShotCooldownTimer.start()

 
func _on_shot_cooldown_timer_timeout() -> void:
	can_shoot = true


func _on_secondary_shot_cooldown_timer_timeout() -> void:
	can_shoot_secondary = true  


 
#func set_hit_points( value ) ->void: 
	#hit_points = value
	#hit_points_changed.emit( hit_points / max_hit_points )
	#if hit_points <= 0: 
		#set_state(DEAD)
		#explode() 
		#
func got_shot( damage: float) -> void:
	print( "GOT SHOT: " + str(curr_state))
	if curr_state == ALIVE:
		hit_points -= damage
		if hit_points <= 0: 
			set_state(DEAD)
			explode() 

func _on_area_entered(area: Area2D) -> void:
	print("CRASH? " + str(curr_state))
	if curr_state == ALIVE and ( area.is_in_group("rocks") or area.is_in_group("ufos") ) :
		hit_points = 0
		set_state(DEAD)
		area.explode()
		explode()

func explode() ->void:
	$ExplosionSound.play()
	$Explosion.show()
	$Explosion.play()
	death.emit()
	await $Explosion.animation_finished
	$Explosion.hide()




func _on_invul_timer_timeout() -> void:
	set_state( ALIVE ) # Replace with function body.

func respawn() ->void:
	print("RESPAWN")
	hit_points = max_hit_points
	position = GameManager.playarea / 2.0
	set_state( INVUL )
	$Sprite2D.show()
	$InvulTimer.start()
