extends Area2D

signal hit

@export var speed = 300
var velocity = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#print( velocity )
	position += speed * velocity * delta


func reset( pos : Vector2 ) -> void:
	position = pos;
	$CollisionShape2D.disabled = false
	show()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("rocks"): 
		print("CRASH!!")
		$CollisionShape2D.set_deferred("disabled", true )
		hide() 
		hit.emit()
