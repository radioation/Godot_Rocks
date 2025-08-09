extends Area2D

signal exploded

var radius = 128
var velocity: Vector2= Vector2.ZERO

var hit_points = 15

func start( pos, vel ) -> void:
	position = pos  
	velocity = vel
	hit_points = 30
	$AnimatedSprite2D.frame = randi() % 5 * 10 
	$AnimatedSprite2D.play( "Rock" + str( randi() %4 + 1))
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	radius = $CollisionShape2D.shape.radius



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += velocity #* delta
	
	# TODO:  FIX THESE HARD CODED VALUES
	if position.x < 0:
		position.x = GameManager.playarea.x
	elif position.x > GameManager.playarea.x:
		position.x = 0

	if position.y < 0:
		position.y =GameManager.playarea.y
	elif position.y > GameManager.playarea.y:
		position.y = 0
 

func hit( value ): 
	hit_points -= value 
	$HitSound.play()
	if hit_points <= 0:
		explode()


func explode():
	$CollisionShape2D.set_deferred("disabled", true )
	
	$AnimatedSprite2D.hide()
	$Explosion.play()
	$ExplosionSound.play()
	$Explosion.show()
	
	exploded.emit( )
 
	await $Explosion.animation_finished
	
	queue_free()
