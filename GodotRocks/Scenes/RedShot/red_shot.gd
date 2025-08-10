extends Area2D

@export var speed = 800
@export var fire_rate = 0.333333
@export var shot_damage = 2.0 
var velocity = Vector2.ZERO

func start(pos: Vector2, dir : Vector2 ) -> float: 
	position = pos
	velocity = dir * speed
	$ShotSound.play()
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
	if area.name == "Player":
		area.got_shot( shot_damage)
		queue_free()

	if area.is_in_group("rocks"):
		area.hit(shot_damage)  # TODO: if destroyed by UFO shouldn't count towards player scoor
		queue_free()
