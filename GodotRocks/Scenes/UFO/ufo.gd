extends Area2D


class_name Ufo


signal destroyed

@export var target: Area2D = null
@export var threat_range: float = 200.0
@export var red_shot_scene : PackedScene

#enum { SEEK, FLEE }

var velocity: Vector2= Vector2.ZERO
var heading: Vector2 = Vector2(1,0)
var side: Vector2 = Vector2(0,1)
var acceleration: Vector2 = Vector2.ZERO
var max_force : float = 0.0
var max_speed : float = 0.0
var radius : float = 20.0

var hit_points = 20

var score_pts = 75

var seek_player :bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	set_physics_process(true) 
	
	
	target = get_tree().get_nodes_in_group("player")[0]
	
	 
	velocity = Vector2( 0,0 )
	acceleration = Vector2.ZERO
	max_speed =  4    # 4.0 @  60fps or 4*60 - 240 pixles/frame
	max_force = 0.2    # 0.1  @ px/sec^2  ??? I guess 0.1 & 60^2 = 6 * 60 = 360  
 
	seek_player = true
	radius = $CollisionShape2D.shape.radius
	$ShotTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	#seek_target_weighted( delta,  target.global_position, 0.8 )
	#separate_weighted(delta, 1.55)
	if seek_player:
		seek_target(delta,  target.global_position)
	else: 
		flee_target(delta,  target.global_position)
		
		
	velocity += acceleration # *delta
	velocity = velocity.limit_length(max_speed)
	
	# update position
	position += velocity #* delta
	acceleration = Vector2.ZERO

 
func seek_target(delta: float, target_position: Vector2) -> void:
	if (position - target_position).length() <  threat_range :
		seek_player = false
		return
	var desired = (target_position - position).normalized()   
	desired = desired * max_speed 
	var  steer = desired - velocity 
	steer = steer.limit_length(max_force) 
	acceleration += steer  
	
			
func flee_target(delta: float, target_position: Vector2) -> void:
	if (position - target_position).length() > 2.0 * threat_range :
		seek_player = true
		return
	var desired = (position - target_position ).normalized()   
	desired = desired * max_speed 
	var  steer = desired - velocity 
	steer = steer.limit_length(max_force) 
	acceleration += steer  
 


func hit( value ): 
	hit_points -= value 
	if hit_points <= 0:
		explode()


func explode():  
	$ExplosionSound.play()
	$ExplosionSound.play()
	$CollisionShape2D.set_deferred("disabled", true )
	$AnimatedSprite2D.hide()
	$Explosion.show()
	$Explosion.play()
	
	destroyed.emit( score_pts )
	
	await $Explosion.animation_finished
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_shot_timer_timeout() -> void: 
	# shoot at player
	var dir = (target.position - position).normalized() 
	var shot = red_shot_scene.instantiate()
	get_tree().root.add_child(shot)
	var f_rate = shot.start( position, dir )
	$ShotTimer.start()
	
	
