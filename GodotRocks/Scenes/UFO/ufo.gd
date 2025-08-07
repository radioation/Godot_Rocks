extends Area2D

class_name Ufo


@export var target: Area2D = null

var velocity: Vector2= Vector2.ZERO
var heading: Vector2 = Vector2(1,0)
var side: Vector2 = Vector2(0,1)
var acceleration: Vector2 = Vector2.ZERO
var max_force : float = 0.0
var max_speed : float = 0.0
var radius : float = 20.0


 
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	set_physics_process(true) 
	
	
	target = get_tree().get_nodes_in_group("player")[0]
	
	 
	velocity = Vector2( 0,0 )
	acceleration = Vector2.ZERO
	max_speed =  4    # 4.0 @  60fps or 4*60 - 240 pixles/frame
	max_force = 0.2    # 0.1  @ px/sec^2  ??? I guess 0.1 & 60^2 = 6 * 60 = 360  
 
 

	radius = $CollisionShape2D.shape.radius

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	seek_target_weighted( delta,  target.global_position, 0.8 )
	separate_weighted(delta, 1.55)
	
	
	velocity += acceleration # *delta
	velocity = velocity.limit_length(max_speed)
	
	# update position
	position += velocity #* delta
	acceleration = Vector2.ZERO

func separate_weighted(delta: float, weight: float) -> void:
	var desired_separation : float= radius * 3
	
	var sum = Vector2.ZERO 
	var count : int = 0
 
	var vehicles  = get_tree().get_nodes_in_group("ufos")
	var nearby_obs: Array[Node] = []
	for vehicle in vehicles:
		var d =  global_position.distance_to(vehicle.global_position)
		if d > 0 and d < desired_separation:
			var diff : Vector2 = global_position - vehicle.global_position
			diff = diff.normalized()
			diff = diff / d
			sum = sum + diff
			count = count + 1
	if count > 0 :
		sum = sum / float(count)
		sum = sum.normalized()
		# Implement Reynolds: Steering = Desired - Velocity
		sum.limit_length(max_speed)
		
		var  steer = sum - velocity 
		steer = steer.limit_length(max_force) 
		acceleration += steer 
		acceleration *= weight
		
func seek_target_weighted(delta: float, target_position: Vector2, weight: float) -> void:
	var desired = (target_position - position).normalized()   
	desired = desired * max_speed 
	var  steer = desired - velocity 
	steer = steer.limit_length(max_force) 
	acceleration += steer 
	acceleration *= weight
