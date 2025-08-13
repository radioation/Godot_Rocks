extends RigidBody2D

@export var power : float = 400
@export var rotate_power : float = 3000



var thrust = Vector2.ZERO
var rotation_dir : float = 0.0
var playarea : Vector2 = Vector2.ZERO

func _ready() -> void:
	pass

func _process( delta: float ) -> void:
	get_input()
	
func _physics_process(delta: float) :
	constant_force = thrust
	constant_torque = rotation_dir * rotate_power
	
func get_input():  
	if Input.is_action_pressed("thrust"):  
		thrust = transform.x * power
 
	rotation_dir = Input.get_axis("rotate_left", "rotate_right")
 
func _integrate_forces(physics_state: PhysicsDirectBodyState2D) :
	var xform = physics_state.transform
	xform.origin.x = wrapf( xform.origin.x, 0, playarea.x)
	xform.origin.y = wrapf( xform.origin.y, 0, playarea.y)
	
	physics_state.transform = xform
