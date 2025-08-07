extends Sprite2D


@export var rotation_textures: Array[Texture2D] 
var num_textures

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	num_textures = rotation_textures.size()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:  
		var parent_rotation = get_parent().global_rotation + 0.09817477 # Get the parent's current rotation in radians  
		var normalized_rotation = fmod(parent_rotation, TAU) # TAU is 2 * PI
		
		if normalized_rotation < 0:
			normalized_rotation += TAU 
		
		var texture_index = int(normalized_rotation / TAU * num_textures) 
		
		print( "p-rot: " + str(parent_rotation) + " ind: " + str(texture_index))
		global_rotation = 0 # override rotation so we can supply a frame with the right ligthing
		texture = rotation_textures[texture_index]     
