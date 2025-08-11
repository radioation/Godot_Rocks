extends Control

@onready var tex_rect: TextureRect = $TextureRect
@onready var overlay: Label = $Overlay


var file_path : String = ""
var image_size := Vector2.ZERO

var zoom : float= 1.0


var pan := Vector2.ZERO
var dragging : bool= false
var drag_start := Vector2.ZERO

@export var zoom_min: float = 0.05
@export var zoom_max: float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func load_image(path: String) -> void:
	file_path = path
	var img := Image.new()
	var err := img.load(path)
	if err != OK:
		push_error("Failed to load image: %s" % path)
		return
	image_size = Vector2(img.get_width(), img.get_height())
	var tex := ImageTexture.create_from_image(img)
	tex_rect.texture = tex
	overlay.text = "%s   (%.0fx%.0f)" % [path.get_file(), image_size.x, image_size.y]
	_update_layout()


func _gui_input(e: InputEvent) -> void:
	if e is InputEventMouseButton:
		var mb := e as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_WHEEL_UP and mb.pressed:
			zoom = clamp(zoom * 1.1, zoom_min, zoom_max)
			_update_layout()
		elif mb.button_index == MOUSE_BUTTON_WHEEL_DOWN and mb.pressed:
			zoom = clamp(zoom / 1.1,  zoom_min, zoom_max)
			_update_layout()
		elif mb.button_index == MOUSE_BUTTON_LEFT:
			dragging = mb.pressed
			drag_start = get_local_mouse_position()
	elif e is InputEventMouseMotion and dragging:
		var mm := e as InputEventMouseMotion
		pan += mm.relative
		_update_layout()

func _update_layout() -> void: 
	if tex_rect.texture:
		print("ZOOM: %.4f" % zoom )
		var scaled := image_size * zoom
		
		tex_rect.expand = true
		tex_rect.custom_minimum_size = scaled
		tex_rect.size = scaled
		tex_rect.position = (size - scaled) * 0.5  + pan
		overlay.text = "%s  |  Zoom: %.2fx" % [file_path.get_file(), zoom]
