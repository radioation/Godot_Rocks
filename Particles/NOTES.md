# Basic Particles
* Use GPUParticles2D instead of CPUParticles2D as there are no plans to add new features to CPU particles.
  * CPU may perform better on low-end systems 

* You need a ParticleProcessMaterial for the GPUParticles2D node to work.
  `Inspector | GPUParticles2D > Process Material` select `New ParticleProcessMaterial`


# Animated


* You need a ParticleProcessMaterial for the GPUParticles2D node to work.
  `Inspector | GPUParticles2D > Process Material` select `New ParticleProcessMaterial`
* add your texture/spritesheet to `Inspector | > GPUParticles2D > Texture`
* add a CanvasItermPaterial to `Inspector | CanvasItem > Material`
  * check `Particles Animation` to turn it on : `Inspector | CanvasItem > Materia > Particles Animation`
  * set number of horizontal and vertical frames : `Inspector | CanvasItem > Material > H Frame` and
    `Inspector | CanvasItem > Material > V Frame`

ONce you have the CanvasItemMaterial configured, you need to configure the animation in
`INspector | GPUParticls2D > Process Material > Display`.
  * `Display > Scale` ( gives a range of sizes)
  * `DIspaly > Animation > Speed`



# some interesting parameters
* `Time > Lifetime` : how long a particle persists
* `Time > ONe Shot` : emit all paritcles at once and never again ( might be good for sparks on a hit)

* `Time > Explosiveness` : 0 - emit one at a time, 1 - emit all at once ( also good,  )


* `Drawing > Local Coords` : 
* `Drawing > draw order`  : affects who's on top. Lifetme probably best, in that new ones
     are on top. Index gives animated textures a more random look

* `Process Material > Spawn > position` control where it spans
* `Process Material > Spawn > Velocity > Direction` 
* `Process Material > Spawn > Velocity > Initial Velocity`


* `Process Material > Animated Velocity > Radial Velocity` (seems good for explosions )
* `Process Material > Animated Velocity > Orbit Velocity` whirlpool flow

* `Process Material > acceleration > Gravity` : can turn x,y,z to 0 for space game



