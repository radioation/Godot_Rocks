extends Node2D




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_tree().get_root().size_changed.connect(update_child_scale)
	update_child_scale()

func _enter_tree() -> void:
	get_viewport().size_changed.connect(update_child_scale)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_SIZE_CHANGED:
		update_child_scale()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_child_scale() -> void:
	var viewport_size = get_viewport_rect().size
	
	# get scale factors
	var scale_x:float = viewport_size.x / $View.screen_w
	var scale_y:float = viewport_size.y / $View.screen_h
	var scale_min = min( scale_x, scale_y)
	$View.scale = Vector2( scale_min, scale_min)
	
	# and center
	var offset_x = (viewport_size.x - $View.screen_w * scale_min) * 0.5
	var offset_y = (viewport_size.y - $View.screen_h * scale_min) * 0.5
	$View.position = Vector2(offset_x, offset_y )
	
