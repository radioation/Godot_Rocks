extends Area2D


@export var speed = 1000
@export var fire_rate = 0.07
var velocity = Vector2.ZERO

func start(xform ) -> float:
	transform = xform
	print( "BLUE transform,x " + str(transform.x))
	print( "BLUE transform " + str(transform))
	velocity = transform.x * speed
	return fire_rate
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
