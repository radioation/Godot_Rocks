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
