# basic setup

* turn off filter for rendering textures:
  * `Project Settings | Rendering > Textures > Canvas Texture > Default Textue Filter` : Nearest
  * `Project Settings | Dixplay > WIndow > Stretch > Mode` : `canvas_item`
  * `Project Settings | Dixplay > WIndow > Stretch > Aspect` : `expand`
  

* Setup layer names for physics
  * `Project Settings | Layer Names > 2D Physics` 
    * Layer 1: env
    * Layer 2: player
    * Layer 3: mobs

## CharacterBody2D
* make Player scene from `CharacterBody2D`
  * `Inspector | CharacterBody2D > MOtion Mode` : Grounded  # so we have a "floor" direction
  * `Inspoector | CollisionObject2D > Collision > Layer `: set to player ( #2 )
  * `Inspoector | CollisionObject2D > Collision > Mask `: set env, player, and mobs 
        (do I neve need player?)

* Add `AnimatedSprite2D` to the player
  * use `Inspector | AnimatedSprite2D > Animation >SpriteFrames` to setup 
    animations

* set player' Sprite's node2d position to (0, -32) so that 0,0 is where the feet are


* Add RectangleShape2D to Player and fit it to the sprite

## Scripting
* add a script, you'll eventualy want states for: IDLE, WALK, JUMP

to set the animation based on state use 
```gd
		IDLE:
			$AnimatedSprite2D.play("idle")
		WALK:
			$AnimatedSprite2D.play("walk")
		JUMP:
			$AnimatedSprite2D.play("jump")
```

and use input to set motion and state

```gd
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



```
for this to mean anything, update `_physics_process()`

```gd
func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	read_input()
	move_and_slide()
```

## Simple Platform
* Instantiate a Player in your main scene

* Add a `StaticBody2D` with a `CollisionShape2D` child (with rectangle shape) for a platform
  ( so `Main > StaticBody2D > CollisionShape2D`  )

* Position both the player and shape in your screen  (use your judgement)
* check `Debug > Visible Collision Shape` so you can see the platform when you run
  the game.



# Basic tilemap(Layer)
[this](https://docs.godotengine.org/en/stable/tutorials/2d/using_tilesets.html) but for my image
**IMP** TileMap is deprecated. Use multiple TileMapLayer nodes instead.

* Added TileMapLayer to Main scend
  * Use `Inspector | TileMapLAyer > Tile Set` to create a new `TileSet`
    * Use `Inspector | TileMapLAyer > Tile Set > Tile Shape` to `Square`
    * Use `Inspector | TileMapLAyer > Tile Set > Tile Size` to `32,32`
* Click `TileSet` at the bottom of the editor and drag tileshee to it
  (let it automagically create the tiles)
  * gave it a name 'Terrain' in the Bottom editor ( under Atlas)

## Add collision
* need to craete physics layer. 
  * Select the `TileMapLayer` node  and use 
    `Inspector | TileMapLayer > Tile Set > Physics Layers > + Add Element`
     to create a physics layer

**IMP** if you *ACTUALLY SELECT* a tile, you can see a `Physics` section 
in the TIleSet Atlas 
  for a selected tile press `F` to create a collision rectangle. 
  * Edit the shapes as needed

**IMP** SEAMS MATTER. IF your collision shapes don't exaclty match, your player 
may catch on an edge  **TURN ON THE GID SNAP TOOL** (looks like a little horseshoe magnet)

**IMP** ONE WAY TILES (so you can jump up through them )
  * when you mkae your collison shape, expand the `Polygon` below
    it and check the `One Way` checkbox. Default behavior lets you fall through



## Make Level
* select `TileMap` at the bottom of the editor to start editing the tilemaplayer
 * choose tile in the bottom window
 * place them in the main window area






# scrolling playfield
* just draw a big playfield and *ADD A CAMERA2D* to the playerw 
* set `Inspector | Camera2D > Limit` to whaever fits your level.


