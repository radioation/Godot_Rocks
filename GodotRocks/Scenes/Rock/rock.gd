extends Area2D

signal exploded


var radius = 128
var velocity: Vector2= Vector2.ZERO

var hit_points: int = 15
var margin:float = 256.0

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
	
	if position.x < -margin :
		position.x = GameManager.playarea.x + margin
	elif position.x > GameManager.playarea.x + margin:
		position.x = -margin

	if position.y < -margin:
		position.y = GameManager.playarea.y + margin
	elif position.y > GameManager.playarea.y + margin:
		position.y = -margin
 

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
