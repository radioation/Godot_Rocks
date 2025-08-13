# Player camera
Player Camera2D Limits are  set to play are size

 * `Camera2D > Limit > Left` = 0
 * `Camera2D > Limit > right` = 0
 * `Camera2D > Limit > Top` = 2560
 * `Camera2D > Limit > Bottom` = 1600


# Mini-map
* need second camera? 
* Needs :
  * `CanvasLayer`
    * `SubViewportContainer` ( anchor somewhere in canvas and turn on
      `stretch` )
      * `SubViewport`
        * Camera2D
  

## SubViewport Script

* point SubViewport at main world

```gd
func _ready() -> void:
    # point subviewport at main world
    world_2d = get_tree().root.world_2d
```

* To make it follow the player, add some exports for
  the player scene and the `SubViewport` camera

```gd
@export var camera_2d : Node2D
@export var player : RigidBody2D

```
  and update the camera position to match the player position

```gd
func _process(delta: float) -> void:
    camera_2d.position = player.position
```
which will move the camera around with the player.


* I want the minimap to show the entire play field, so I set the
  SubViewportContainer size to 1/10 of the play area:

  `Inspector | Control > Transform > Size` (256.0, 160.0)

  * I also set the `SubViewport` camera zoom to `0.1`  
    and limits to match the play area:
   `Camera2D > Limit > Left` = 0
   `Camera2D > Limit > right` = 0
   `Camera2D > Limit > Top` = 2560
   `Camera2D > Limit > Bottom` = 1600
  


# Simpler minimap
* added a Sprite2D to main with simplified background (`bg_tenth.png`)
  * scaled sprite up to match the main background size
  * changed the visibility layer of this background sprite to 2 (removed 1)

* Added layer 2 to the Main scene's visibility layer
* updated main.gd to set the main view port to disable rendering layer 2

```gd
func _ready() -> void:
    #playarea = get_viewport().get_visible_rect().size
    playarea = Vector2( 2560, 1600)

    # Get the root Viewport
    var main_viewport = get_tree().root.get_viewport()

    # Disable rendering of Layer 2 in the main view
    if main_viewport.canvas_cull_mask & 2:
        main_viewport.canvas_cull_mask = main_viewport.canvas_cull_mask - 2 # -2 for Layer 2, 
```
* Set the Sprite2D Visibility Layer to 2 for both the Ship and Rock scenes.

* updated main.gd to set the visibility layer of rocks it spawns
```gd
func spawn_rocks( count : int ) -> void:
    for i in count:
        var r = rock_scene.instantiate()    
        r.playarea = playarea
        r.position = Vector2( randf_range(0, playarea.x), randf_range(0, playarea.y))
        r.linear_velocity = Vector2.RIGHT.rotated(randf_range(0, TAU)) * randf_range( 225.0, 250.0)
        r.visibility_layer = r.visibility_layer + 2
        add_child(r)
```

* selected Subviewport and took layer 1 out of its cull mask

**IMPORTANT** 
1. Set your minimap-only items to layer 2 and your main viewarea objects to layer 1.
2. Make sure parents of your layer 2 objects also have layer 2 (this includes instances
  in the main scene along with the sprites in the object scenes)

## Simplified minimap Sprites
You can add a second Sprite to your scenes and set their visibility to layer 2. The full size
sprites should be set to layer 1 so they only render in the main viewport.




