extends Area2D

@export var speed = 800
@export var fire_rate = 0.25
var velocity = Vector2.ZERO


func start(xform ) -> float:
	transform = xform
	velocity = transform.x * speed
	return fire_rate
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += velocity * delta
