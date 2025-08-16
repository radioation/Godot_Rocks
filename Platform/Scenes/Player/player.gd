extends CharacterBody2D

@export var walk_speed = 200
@export var jump_speed = -200
@export var gravity = 400


enum { IDLE, WALK, JUMP }
var current_state = IDLE


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	read_input()
	move_and_slide()

func set_state( new_state ) -> void:
	current_state = new_state
	match current_state:
		IDLE:
			$AnimatedSprite2D.play("idle")
		WALK:
			$AnimatedSprite2D.play("walk")
		JUMP:
			$AnimatedSprite2D.play("jump")


func read_input() -> void:
	velocity.x = 0
	if Input.is_action_pressed("right"):
		velocity.x += walk_speed
		$AnimatedSprite2D.flip_h = false
	if Input.is_action_pressed("left"):
		velocity.x -= walk_speed
		$AnimatedSprite2D.flip_h = true
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		set_state(JUMP)
		velocity.y = jump_speed
	if current_state == IDLE and velocity.x != 0:
		set_state(WALK)
	if is_on_floor() and velocity.x == 0:
		set_state(IDLE)
	if current_state in [WALK, IDLE] and not is_on_floor():
		set_state(JUMP)
	elif current_state == JUMP and is_on_floor():
		set_state(WALK)
