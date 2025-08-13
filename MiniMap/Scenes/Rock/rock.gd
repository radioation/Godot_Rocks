extends RigidBody2D

var playarea = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _integrate_forces(physics_state: PhysicsDirectBodyState2D) :
	var xform = physics_state.transform
	xform.origin.x = wrapf( xform.origin.x, 0, playarea.x )
	xform.origin.y = wrapf( xform.origin.y, 0, playarea.y )
	physics_state.transform = xform
