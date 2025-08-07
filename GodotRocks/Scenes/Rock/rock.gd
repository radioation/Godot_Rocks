extends Area2D
 
var radius = 128
var velocity: Vector2= Vector2.ZERO

var hit_points = 30

func start( pos, vel ) -> void:
	position = pos  
	velocity = vel
	hit_points = 30
	$AnimatedSprite2D.frame = randi() % 60 
	$AnimatedSprite2D.play( "Rock" + str( randi() %4 + 1))
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	radius = $CollisionShape2D.shape.radius



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += velocity #* delta
	
	# TODO:  FIX THESE HARD CODED VALUES
	if position.x < 0:
		position.x = 2560
	elif position.x > 2560:
		position.x = 0

	if position.y < 0:
		position.y =1600
	elif position.y > 1600:
		position.y = 0
 
