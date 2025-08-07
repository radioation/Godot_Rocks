extends Area2D

@export var speed = 200

var bottom = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bottom = get_viewport_rect().end.y + $Sprite2D.texture.get_size().y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += speed * delta
	if position.y > bottom:
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
