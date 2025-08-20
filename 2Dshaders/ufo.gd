extends Node2D


var shader_material: ShaderMaterial

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shader_material = $AnimatedSprite2D.material
	shader_material.set_shader_parameter("ind", 0 )

func set_shade( index : int ) ->  void:
	shader_material.set_shader_parameter("ind", index )


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
