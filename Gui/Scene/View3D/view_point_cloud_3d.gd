extends SubViewportContainer


@onready var cam: Camera3D      = $SubViewport/WorldRoot/Camera3D
@onready var points_root: Node3D = $SubViewport/WorldRoot/PointCloudRoot

@export var point_size: float = 0.05
@export var num_points: int = 360
@export var radius: float = 2.5


var dot_tex: Texture2D
var points: Array[MeshInstance3D] = []


# mouse control 
var left_mouse_down : bool = false
var middle_mouse_down : bool = false
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
			left_mouse_down = mbutton.pressed
			accept_event()
		elif mbutton.button_index == MOUSE_BUTTON_WHEEL_UP :
			distance = max(0.2, distance * 0.9)
			update_camera()
			accept_event()
		elif mbutton.button_index == MOUSE_BUTTON_WHEEL_DOWN :
			distance *= 1.1
			update_camera()
			accept_event()
		elif mbutton.button_index == MOUSE_BUTTON_MIDDLE:
			middle_mouse_down = mbutton.pressed
			accept_event()
	elif e is InputEventMouseMotion:
		var m_motion := e as InputEventMouseMotion
		if left_mouse_down:
			yaw   -= m_motion.relative.x * 0.01
			pitch = clamp(pitch - m_motion.relative.y * 0.01, -1.45, 1.45)
			update_camera()
			accept_event()			
		elif middle_mouse_down:
			var right := cam.global_transform.basis.x
			var up    := cam.global_transform.basis.y
			center -= right * m_motion.relative.x * 0.002 * distance
			center += up    * m_motion.relative.y * 0.002 * distance
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
	mi.material_override  = make_billboard_material(color)
	mi.position = position 
	mi.scale  = Vector3.ONE *  (size if size > 0.0 else point_size)
	print(mi.scale)
	points_root.add_child(mi)
	return mi

func make_billboard_material(color: Color) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.albedo_color = color
	m.albedo_texture = dot_tex
	m.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED   # Aways face camera
	m.billboard_keep_scale = true     
	m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	m.vertex_color_use_as_albedo = false
	m.disable_fog = true
	return m

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
		var pos = Vector3(cos(angle), randf() * 0.6 - 0.3, sin(angle)) * radius
		var color = Color.from_hsv(randf(), 0.8, 1.0, 1.0)
		var n = add_point(pos, color )
		points.append(n)
	
