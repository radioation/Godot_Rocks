extends Node2D

# --- TUNABLES ----------------------------------------------------
#const screen_w : int = 640          # internal render width (columns)
#const screen_h : int = 480          # internal render height
var screen_w : int = 640
var screen_h : int = 480

const FOV : float = deg_to_rad(60.0)  # field of view
const MAX_DIST :float = 20.0          # max ray distance (map units)
const TILE : float= 1.0               # map cell size (world units)

# need a texture for each type of map spot
@export var wall_texture1: Texture2D
@export var wall_texture2: Texture2D
@export var wall_texture3: Texture2D
@export var wall_texture4: Texture2D
@export var sprite_texture: Texture2D

@export	var wall_tex_size : Vector2
@export	var sprite_tex_size : Vector2
@export	var half_h : float

@export var move_speed_d :float = 2.5
@export var rot_speed_d :float= 1.8
# Quick 2D map: 1 = wall, 0 = empty
var world_map := [
  [4,4,4,4,4,4,4,4,4,4,4,4,4,2,4,4,2,4,2,4,4,4,2,4],
  [4,0,0,0,0,0,0,0,0,0,4,4,0,0,0,0,0,0,0,0,0,0,0,4],
  [4,0,3,3,0,0,0,0,0,4,4,4,0,0,0,0,0,0,0,0,0,0,0,2],
  [4,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
  [4,0,3,3,0,0,0,0,0,4,4,4,0,0,0,0,0,0,0,0,0,0,0,4],
  [4,0,0,0,0,0,0,0,0,0,4,4,0,0,0,0,0,2,2,2,0,2,4,2],
  [4,4,4,4,0,4,4,4,4,4,4,4,4,4,4,4,4,2,0,0,0,0,0,2],
  [3,3,3,3,0,3,3,3,3,0,4,0,4,0,4,0,4,4,0,4,0,2,0,2],
  [3,3,0,0,0,0,0,0,3,4,0,4,0,4,0,4,4,2,0,0,0,0,0,2],
  [3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,2,0,0,0,0,0,4],
  [3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,2,0,2,0,2,0,2],
  [3,3,0,0,0,0,0,0,3,4,0,4,0,4,0,4,4,2,4,2,0,2,2,2],
  [3,3,3,3,0,3,3,3,3,4,4,4,0,2,4,4,4,3,3,3,0,3,3,3],
  [2,2,2,2,0,2,2,2,2,4,2,4,0,0,2,0,2,3,0,0,0,0,0,3],
  [2,2,0,0,0,0,0,2,2,4,0,0,0,0,0,0,4,3,0,0,0,0,0,3],
  [3,0,0,0,0,0,0,0,3,4,0,0,0,0,0,0,4,3,0,0,0,0,0,3],
  [1,0,0,0,0,0,0,0,1,4,4,4,4,4,2,0,2,3,3,0,0,0,3,3],
  [2,0,0,0,0,0,0,0,2,2,2,1,2,2,2,2,2,0,0,1,0,1,0,1],
  [2,4,0,0,0,0,0,4,2,2,0,0,0,2,2,0,1,0,1,0,0,0,1,1],
  [2,0,0,0,0,0,0,0,2,0,0,0,0,0,2,1,0,1,0,1,0,1,0,1],
  [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [3,0,0,0,0,0,0,0,3,0,0,0,0,0,2,1,0,1,0,1,0,1,0,1],
  [2,2,0,0,0,0,0,2,2,2,0,0,0,2,2,0,1,0,1,0,0,0,1,1],
  [2,2,3,2,1,2,3,2,2,2,2,1,2,2,2,1,1,1,1,1,1,1,1,1]
]

# Player state
#double posX = 22.0, posY = 11.5;  //x and y start position
#double dirX = -1.0, dirY = 0.0; //initial direction vector (180 == PI)
#double planeX = 0.0, planeY = 0.66; //the 2d raycaster version of camera plane
var pos := Vector2(4.8,21.8)    #  X and Y start position 
#var dir_angle := PI           # radians
#var dir_vec : Vector2
var dir: = Vector2( -1.0, 0.0 )
var plane: = Vector2( 0.0, 0.66 )

# Spreite state
var z_buffer := PackedFloat32Array() # for checking sprite depth when we draw them.
var sprites := PackedVector2Array() # for sprite positions 
var sprite_order := PackedInt32Array() 
var sprite_distance := PackedFloat32Array() 
var sprite_sort_space := PackedVector2Array()

func _ready() -> void:
	z_buffer.resize(screen_w)
	sprites.append( Vector2( 4.0, 22.0))
	sprites.append( Vector2( 4.0, 20.0))
	sprites.append( Vector2( 3.0, 18.0))
	sprites.append( Vector2( 4.0, 16.0))
	sprites.append( Vector2( 4.0, 14.0))
	
	sprite_order.resize(sprites.size())
	sprite_distance.resize(sprites.size())
	sprite_sort_space.resize(sprites.size())
	
	wall_tex_size = wall_texture1.get_size() 
	sprite_tex_size = sprite_texture.get_size()
	
	half_h = screen_h * 0.5
	#dir_vec = Vector2(cos(dir_angle), sin(dir_angle))
	 
	set_process(true)

#  basically handles main loop 
func _process(delta: float) -> void:
	# basically main loop body is in read_input and _draw()
	read_input(delta)
	queue_redraw() # Request a refresh for this node. will  all _draw, which does the DDA
	 
 

# --- INPUT -------------------------------------------------------
func read_input(delta: float) -> void:
	
	#//speed modifiers
	#double moveSpeed = frameTime * 5.0; //the constant value is in squares/second
	#double rotSpeed = frameTime * 3.0; //the constant value is in radians/second
	var move_speed = delta * move_speed_d
	  
	#//move forward if no wall in front of you
	#if(keyDown(SDLK_UP))
	#{
	#if(worldMap[int(posX + dirX * moveSpeed)][int(posY)] == false) posX += dirX * moveSpeed;
	#if(worldMap[int(posX)][int(posY + dirY * moveSpeed)] == false) posY += dirY * moveSpeed;
	#}
	if Input.is_action_pressed("ui_up"):
		if world_map[ int(pos.x + dir.x * move_speed ) ][int(pos.y)] == 0:
			pos.x += dir.x * move_speed 
		if world_map[int(pos.x)][ int(pos.y + dir.y * move_speed ) ] == 0:
			pos.y += dir.y * move_speed 
	#//move backwards if no wall behind you
	#if(keyDown(SDLK_DOWN))
	#{
	#if(worldMap[int(posX - dirX * moveSpeed)][int(posY)] == false) posX -= dirX * moveSpeed;
	#if(worldMap[int(posX)][int(posY - dirY * moveSpeed)] == false) posY -= dirY * moveSpeed;
	#}	
	if Input.is_action_pressed("ui_down"):
		if world_map[ int(pos.x - dir.x * move_speed ) ][int(pos.y)]==0:
			pos.x -= dir.x * move_speed 
		if world_map[int(pos.x)][ int(pos.y - dir.y * move_speed ) ]==0:
			pos.y -= dir.y * move_speed 
	#print("pos: " + str(pos))

	var rot_speed = delta * rot_speed_d
	#//rotate to the right
	#if(keyDown(SDLK_RIGHT))
	#{
	#//both camera direction and camera plane must be rotated
	#double oldDirX = dirX;
	#dirX = dirX * cos(-rotSpeed) - dirY * sin(-rotSpeed);
	#dirY = oldDirX * sin(-rotSpeed) + dirY * cos(-rotSpeed);
	#double oldPlaneX = planeX;
	#planeX = planeX * cos(-rotSpeed) - planeY * sin(-rotSpeed);
	#planeY = oldPlaneX * sin(-rotSpeed) + planeY * cos(-rotSpeed);
	#}	
	if Input.is_action_pressed("right"):
		#dir_angle += rot_speed * delta
		var old_dir = dir
		dir.x = dir.x * cos( - rot_speed ) - dir.y * sin( - rot_speed )
		dir.y = old_dir.x * sin( - rot_speed ) + dir.y * cos( - rot_speed )
		var old_plane = plane
		plane.x = plane.x * cos( -rot_speed) - plane.y * sin( -rot_speed )
		plane.y = old_plane.x * sin( -rot_speed) + plane.y * cos( -rot_speed )
	#//rotate to the left
	#if(keyDown(SDLK_LEFT))
	#{
	#//both camera direction and camera plane must be rotated
	#double oldDirX = dirX;
	#dirX = dirX * cos(rotSpeed) - dirY * sin(rotSpeed);
	#dirY = oldDirX * sin(rotSpeed) + dirY * cos(rotSpeed);
	#double oldPlaneX = planeX;
	#planeX = planeX * cos(rotSpeed) - planeY * sin(rotSpeed);
	#planeY = oldPlaneX * sin(rotSpeed) + planeY * cos(rotSpeed);
	#}

	if Input.is_action_pressed("left"):
		#dir_angle -= rot_speed * delta
		var old_dir = dir
		dir.x = dir.x * cos( rot_speed ) - dir.y * sin( rot_speed )
		dir.y = old_dir.x * sin( rot_speed ) + dir.y * cos( rot_speed )
		var old_plane = plane
		plane.x = plane.x * cos( rot_speed) - plane.y * sin( rot_speed )
		plane.y = old_plane.x * sin( rot_speed) + plane.y * cos( rot_speed )
		
  
	# STRAFE
	var right :Vector2 = dir.orthogonal().normalized()  * move_speed
	if Input.is_action_pressed("ui_right"):
		var temp_pos = pos + right
		if world_map[ int(temp_pos.x ) ][int(temp_pos.y)]==0:
			pos = temp_pos
	if Input.is_action_pressed("ui_left"):
		var temp_pos = pos - right
		if world_map[ int(temp_pos.x ) ][int(temp_pos.y)]==0:
			pos = temp_pos 

 

func sort_sprites() -> void:
	var count = sprites.size()
	var i :int = 0
	while i < count: 
		var j: int = i
		while j > 0 and sprite_distance[j-1] < sprite_distance[j] :
			var tmp:float = sprite_distance[j]
			sprite_distance[j] = sprite_distance[j-1]
			sprite_distance[j-1] = tmp
			
			var tmp_order = sprite_order[j]
			sprite_order[j] = sprite_order[j-1]
			sprite_order[j-1] = tmp_order
			
			j = j-1
		i = i + 1

 
func _draw() -> void:  
	# background
	draw_rect(Rect2(0, 0, screen_w, screen_h/2), Color(0.35, 0.55, 0.9))
	draw_rect(Rect2(0, screen_h/2, screen_w, screen_h/2), Color(0.2, 0.2, 0.22))

		
 
	if wall_texture1 == null:
		return


	#for(int x = 0; x < w; x++)
	#{
	  #//calculate ray position and direction
	for x in range(screen_w):
		#//calculate ray position and direction
		#double cameraX = 2 * x / (double)w - 1; //x-coordinate in camera space
		#double rayDirX = dirX + planeX*cameraX;
		#double rayDirY = dirY + planeY*cameraX;
		var camera_x := (2.0 * x / float(screen_w)) - 1.0  # -1..1 across screen
		#var ray_angle := dir_angle + atan(camera_x * tan(FOV * 0.5) * 2.0)
		var ray_dir := Vector2( dir.x + plane.x * camera_x, dir.y + plane.y * camera_x )
		#print("Pos: " + str(pos))
		#//which box of the map we're in
		#int mapX = int(posX);
		#int mapY = int(posY);
		var map_x: int = int(pos.x)
		var map_y: int = int(pos.y)
		
		#//length of ray from current position to next x or y-side
		#double sideDistX;
		#double sideDistY;
		var side_dist: Vector2
		#//length of ray from one x or y-side to next x or y-side
		#double deltaDistX = (rayDirX == 0) ? 1e30 : std::abs(1 / rayDirX);
		#double deltaDistY = (rayDirY == 0) ? 1e30 : std::abs(1 / rayDirY);
		#double perpWallDist;
		var delta_dist: Vector2 = Vector2( 1e30 if ray_dir.x == 0.0  else abs( 1 / ray_dir.x ), 1e30 if ray_dir.y == 0.0  else abs( 1 / ray_dir.y ) )
		var perp_wall_dist: float
		
		# DDA
		#//what direction to step in x or y-direction (either +1 or -1)
		#int stepX;
		#int stepY;
		#int hit = 0; //was there a wall hit?
		#int side; //was a NS or a EW wall hit?
		var step_x : int
		var step_y : int
		var hit:int = 0
		var side: int

		#//calculate step and initial sideDist
		#if(rayDirX < 0)
		#{
		#stepX = -1;
		#sideDistX = (posX - mapX) * deltaDistX;
		#}
		#else
		#{
		#stepX = 1;
		#sideDistX = (mapX + 1.0 - posX) * deltaDistX;
		#}
		if ray_dir.x < 0:
			step_x = -1
			side_dist.x = ( pos.x - map_x) * delta_dist.x
		else:
			step_x = 1
			side_dist.x = ( map_x + 1.0 - pos.x ) * delta_dist.x
		#if(rayDirY < 0)
		#{
		#stepY = -1;
		#sideDistY = (posY - mapY) * deltaDistY;
		#}
		#else
		#{
		#stepY = 1;
		#sideDistY = (mapY + 1.0 - posY) * deltaDistY;
		#}
		if ray_dir.y < 0:
			step_y = -1
			side_dist.y = ( pos.y - map_y) * delta_dist.y
		else:
			step_y = 1
			side_dist.y = ( map_y + 1.0 - pos.y) * delta_dist.y
		#//perform DDA
		#while (hit == 0)
		#{
		#//jump to next map square, either in x-direction, or in y-direction
		#if(sideDistX < sideDistY)
		#{
			#sideDistX += deltaDistX;
			#mapX += stepX;
			#side = 0;
		#}
		#else
		#{
			#sideDistY += deltaDistY;
			#mapY += stepY;
			#side = 1;
		#}
		#//Check if ray has hit a wall
		#if(worldMap[mapX][mapY] > 0) hit = 1;
		#}
		while hit == 0:
			if side_dist.x < side_dist.y:
				side_dist.x += delta_dist.x
				map_x += step_x
				side = 0
			else:
				side_dist.y += delta_dist.y
				map_y += step_y
				side = 1

			if world_map[map_x][map_y] > 0: 
				hit = 1;
				
			
		#//Calculate distance of perpendicular ray (Euclidean distance would give fisheye effect!)
		#if(side == 0) perpWallDist = (sideDistX - deltaDistX);
		#else          perpWallDist = (sideDistY - deltaDistY);
		#
		if side == 0 :
			perp_wall_dist = side_dist.x - delta_dist.x
		else:
			perp_wall_dist = side_dist.y - delta_dist.y
			
		#print("perp wall dist " + str(perp_wall_dist))
		if perp_wall_dist <= 0.0001:
			perp_wall_dist = 0.0001

		#//Calculate height of line to draw on screen
		#int lineHeight = (int)(h / perpWallDist); 
		var line_height := int(screen_h / perp_wall_dist)
		var pitch :int = 100

		#//calculate lowest and highest pixel to fill in current stripe
		#int drawStart = -lineHeight / 2 + h / 2 + pitch;
		#if(drawStart < 0) drawStart = 0;
		#int drawEnd = lineHeight / 2 + h / 2 + pitch;
		#if(drawEnd >= h) drawEnd = h - 1;
		# Destination rect for this screen column
		var draw_start := int(half_h - line_height / 2)
		var dest_rect := Rect2(x, draw_start, 1, line_height)  # 1 pixel wide column

		#//texturing calculations
		#int texNum = worldMap[mapX][mapY] - 1; //1 subtracted from it so that texture 0 can be used!


		#//calculate value of wallX
		#double wallX; //where exactly the wall was hit
		#if(side == 0) wallX = posY + perpWallDist * rayDirY;
		#else          wallX = posX + perpWallDist * rayDirX;
		#wallX -= floor((wallX));
		var wall_x: float
		if side == 0 :
			wall_x = pos.y + perp_wall_dist * ray_dir.y
		else:
			wall_x = pos.x + perp_wall_dist * ray_dir.x
		wall_x -= floor((wall_x))

		var tex_u := int(clamp(floor(wall_x * wall_tex_size.x), 0, wall_tex_size.x - 1))



		# Source rect: 1px wide vertical strip across the full wall texture height
		var src_rect := Rect2(tex_u, 0, 1, wall_tex_size.y)

		# Simple shading for distance.
		var shade : float= clamp(1.0 / (0.6 + perp_wall_dist * 0.25), 0.2, 1.0)
		if side == 0 and ray_dir.x > 0.0:
			shade *= 0.4
		if side == 1 and ray_dir.y < 0.0:
			shade *= 0.4
			
		var wall_texture: Texture2D = wall_texture1
		var texture_num = world_map[ map_x][map_y]
		if texture_num == 1:
			wall_texture = wall_texture1
		elif texture_num == 2:
			wall_texture = wall_texture2
		elif  texture_num == 3:
			wall_texture = wall_texture3
		elif  texture_num == 4:
			wall_texture = wall_texture4
		#print("dest_rect : " + str(dest_rect) + " src: " + str(src_rect))
		
		draw_texture_rect_region(
			wall_texture,
			dest_rect,
			src_rect,                 # no tile
			Color(shade, shade, shade, 1.0)
		)
		
		# for sprite casting
		z_buffer[x] = perp_wall_dist 
		
		
	#//SPRITE CASTING
	#//sort sprites from far to close
	#for(int i = 0; i < numSprites; i++)
	#{
	#spriteOrder[i] = i;
	#spriteDistance[i] = ((posX - sprite[i].x) * (posX - sprite[i].x) + (posY - sprite[i].y) * (posY - sprite[i].y)); //sqrt not taken, unneeded
	#}
	#sortSprites(spriteOrder, spriteDistance, numSprites);
	for i in range( sprites.size() ) :
		sprite_order[i] = i
		sprite_distance[i] = (pos.x - sprites[i].x)* (pos.x - sprites[i].x) + (pos.y - sprites[i].y) * (pos.y - sprites[i].y)
	
	sort_sprites()
	
	
	#//after sorting the sprites, do the projection and draw them
	#for(int i = 0; i < numSprites; i++)
	#{
	for i in range( sprites.size() ) :
		#//translate sprite position to relative to camera
		#double spriteX = sprite[spriteOrder[i]].x - posX;
		#double spriteY = sprite[spriteOrder[i]].y - posY;
		var sprite_pos = sprites[sprite_order[i]] - pos
		
		#//transform sprite with the inverse camera matrix
		#// [ planeX   dirX ] -1                                       [ dirY      -dirX ]
		#// [               ]       =  1/(planeX*dirY-dirX*planeY) *   [                 ]
		#// [ planeY   dirY ]                                          [ -planeY  planeX ]
		#
		#double invDet = 1.0 / (planeX * dirY - dirX * planeY); //required for correct matrix multiplication
		#double transformX = invDet * (dirY * spriteX - dirX * spriteY);
		#double transformY = invDet * (-planeY * spriteX + planeX * spriteY); //this is actually the depth inside the screen, that what Z is in 3D, the distance of sprite to player, matching sqrt(spriteDistance[i])
		#int spriteScreenX = int((w / 2) * (1 + transformX / transformY));
		var inv_det : float = 1.0 / ( plane.x * dir.y - dir.x * plane.y) 
		var transform_x = inv_det * ( dir.y * sprite_pos.x - dir.x * sprite_pos.y )
		var transform_y = inv_det * ( -plane.y * sprite_pos.x + plane.x * sprite_pos.y )
		
		var sprite_screen_x = int ( (screen_w/2) * ( 1 + transform_x/ transform_y))
		#//parameters for scaling and moving the sprites
		##define uDiv 1
		##define vDiv 1
		##define vMove 0.0
		#int vMoveScreen = int(vMove / transformY);
		var v_move: float = 0.0
		var v_move_screen : int = int ( v_move / transform_y) 
		#//calculate height of the sprite on screen
		#int spriteHeight = abs(int(h / (transformY))) / vDiv; //using "transformY" instead of the real distance prevents fisheye
		#//calculate lowest and highest pixel to fill in current stripe
		#int drawStartY = -spriteHeight / 2 + h / 2 + vMoveScreen;
		#if(drawStartY < 0) drawStartY = 0;
		#int drawEndY = spriteHeight / 2 + h / 2 + vMoveScreen;
		#if(drawEndY >= h) drawEndY = h - 1;
		var sprite_height = abs( int (screen_h/ transform_y))
		var sprite_draw_start := int( half_h - sprite_height/2) + v_move_screen
		
		
		#//calculate width of the sprite
		#int spriteWidth = abs(int (h / (transformY))) / uDiv; // same as height of sprite, given that it's square
		#int drawStartX = -spriteWidth / 2 + spriteScreenX;
		#if(drawStartX < 0) drawStartX = 0;
		#int drawEndX = spriteWidth / 2 + spriteScreenX;
		#if(drawEndX > w) drawEndX = w;
		var sprite_width = sprite_height # abs( int( screen_h / transform_y))
		var draw_start_x = - sprite_width / 2 + sprite_screen_x
		if draw_start_x < 0 :
			draw_start_x = 0
		var draw_end_x = sprite_width /2 + sprite_screen_x 
		if draw_end_x > screen_w: 
			draw_end_x = screen_w
		
		var sprite_shade : float= clamp(1.0 / (0.6 + transform_y * 0.25), 0.2, 1.0)
		#//loop through every vertical stripe of the sprite on screen
		#for(int stripe = drawStartX; stripe < drawEndX; stripe++)
		#{
		for current_stripe in range( draw_start_x, draw_end_x, 1 ):
			
			#int texX = int(256 * (stripe - (-spriteWidth / 2 + spriteScreenX)) * texWidth / spriteWidth) / 256;
			var texture_x = int(256 * (current_stripe - (-sprite_width / 2 + sprite_screen_x)) * sprite_tex_size.x / sprite_width) / 256;
			var sprite_src_rect := Rect2(texture_x, 0, 1, sprite_tex_size.y)
			#//the conditions in the if are:
			#//1) it's in front of camera plane so you don't see things behind you
			#//2) ZBuffer, with perpendicular distance
			#if(transformY > 0 && transformY < ZBuffer[stripe])
			#{
			if transform_y > 0 and transform_y < z_buffer[current_stripe]:
				var sprite_dest_rect := Rect2(current_stripe, sprite_draw_start, 1, sprite_height)  # 1 pixel wide column
				draw_texture_rect_region(sprite_texture,
				sprite_dest_rect,
				sprite_src_rect,
				Color(sprite_shade, sprite_shade, sprite_shade, 1.0) )             
		 

	
		  #for(int y = drawStartY; y < drawEndY; y++) //for every pixel of the current stripe
		  #{
			#int d = (y - vMoveScreen) * 256 - h * 128 + spriteHeight * 128; //256 and 128 factors to avoid floats
			#int texY = ((d * texHeight) / spriteHeight) / 256;
			#Uint32 color = texture[sprite[spriteOrder[i]].texture][texWidth * texY + texX]; //get current color from the texture
			#if((color & 0x00FFFFFF) != 0) buffer[y][stripe] = color; //paint pixel if it isn't black, black is the invisible color
		  #}
		#}
	  #}
	#}


			
			
 
 
