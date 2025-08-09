extends Area2D


@export var speed = 800
@export var fire_rate = 0.25
@export var shot_damage = 10
var velocity = Vector2.ZERO


func start(xform ) -> float:
	$ShotSound.play()
	transform = xform
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

 


func _on_area_entered(area: Area2D) -> void:
	print("AREA ENTERED")
	if area.is_in_group("ufos"):
		print("call hit")
		area.hit(shot_damage)
		queue_free()
	if area.is_in_group("rocks"):
		area.hit(shot_damage)
		queue_free()
