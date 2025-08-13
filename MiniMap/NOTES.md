# Player camera
Player Camera2D Limits are  set to play are size

 * `Camera2D > Limit > Left` = 0
 * `Camera2D > Limit > right` = 0
 * `Camera2D > Limit > Top` = 2560
 * `Camera2D > Limit > Bottom` = 1600


# Minimap
* need seecon camera? 
* Needs :
  * CanvasLayer
    * SubViewportContainer ( anchor somehwere in canvas and turn on
      `stretch` )
      * SubViewport
        * Camera2D
  

## SubViewport Script

* point SubViewport at main world

```gd
func _ready() -> void:
    # point subviewport at main world
    world_2d = get_tree().root.world_2d
```

* To make it follow the player, add some exports for
  the player scene and the SubViewport's camera

```gd
@export var camera_2d : Node2D
@export var player : RigidBody2D

```
  and update the caemra position to match the player position

```gd
func _process(delta: float) -> void:
    camera_2d.position = player.position
```
which will move the camera around with the player.


* I want the minimap to show the entire playfield, so I set the
  SubViewportContainer size to 1/10 of the play area:

  `Inspector | Control > Transform > Size` (256.0, 160.0)

  * I also set the SubViewport's camera zoom to `0.1`  
    and limits to match the play area:
   `Camera2D > Limit > Left` = 0
   `Camera2D > Limit > right` = 0
   `Camera2D > Limit > Top` = 2560
   `Camera2D > Limit > Bottom` = 1600
  

