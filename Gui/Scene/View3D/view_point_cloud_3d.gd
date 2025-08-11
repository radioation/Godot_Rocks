extends SubViewportContainer


@onready var cam: Camera3D      = $SubViewport/WorldRoot/Camera3D
@onready var points_root: Node3D = $SubViewport/WorldRoot/PointCloudRoot

@export var point_size: float = 0.05
@export var num_points: int = 360
@export var radius: float = 2.5


var dot_tex: Texture2D
var points: Array[MeshInstance3D] = []


# mouse control 
var mouse_down : bool = false
var yaw : float = 0.0
var pitch : float = -0.25
var distance : float = 6.0
var center := Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dot_tex = make_dot_texture(64)
	create_points()
 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	set_process(true)
	
	
	
func _gui_input(e: InputEvent) -> void: 
	if e is InputEventMouseButton: 
		var mbutton := e as InputEventMouseButton
		if mbutton.button_index == MOUSE_BUTTON_LEFT:
			mouse_down = true
	elif e is InputEventMouseMotion:
		var m_motion := e as InputEventMouseMotion
		if mouse_down:
			yaw   -= m_motion.relative.x * 0.01
			pitch = clamp(pitch - m_motion.relative.y * 0.01, -1.45, 1.45)
			update_camera()
			accept_event()			
			
			
func update_camera() -> void:
	var dir := Vector3(
		cos(pitch) * sin(yaw),
		sin(pitch),
		cos(pitch) * cos(yaw)
	)
	cam.global_transform.origin = center - dir * distance
	cam.look_at(center, Vector3.UP)
	
func add_point(position: Vector3, color: Color = Color.WHITE, size: float = -1.0) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	mi.mesh = QuadMesh.new()
	#mi.material_override  
	mi.position = position 
	mi.scale  = Vector3.ONE * (size if size > 0.0 else point_size)
	points_root.add_child(mi)
	return mi
	
func make_dot_texture(size: int) -> Texture2D:
	size = clamp(size, 8, 512)
	var img := Image.create(size, size, false, Image.FORMAT_RGBA8)
	 
	var r := float(size - 2) * 0.5
	var center := Vector2(size * 0.5, size * 0.5)
	for y in size:
		for x in size:
			var d := (Vector2(x, y) - center).length()
			var a : float = clamp(1.0 - (d - (r - 1.0)) * 0.15, 0.0, 1.0)  # soft edge
			var col := Color(1, 1, 1, a)
			img.set_pixel(x, y, col)
	 
	return ImageTexture.create_from_image(img)

func create_points() -> void:
	for i in num_points:
		var angle = TAU * float(i) / float(max(1, num_points))
		var p = Vector3(cos(angle), randf() * 0.6 - 0.3, sin(angle)) * radius
		var c = Color.from_hsv(randf(), 0.8, 1.0, 1.0)
		var n = add_point(p, c)
		points.append(n)
	
