
world
	fps = 24
	mob = /mob/Player
	view = "30x30"
	New()
		spawn(3)
			ProcessMapBlock(locate(1,1,1), locate(world.maxx, world.maxy, world.maxz))
			UpdateAllLights()

			#ifndef HIDE_STATIC_LIGHTS
			GenerateStaticLighting()
			#endif

/*
			#ifdef SKIP_STATIC_GEN
			#warn SKIP_STATIC_GEN flag is on
			world.log << "WARNING: SKIP_STATIC_GEN flag is on"
			#endif

			#ifdef HIDE_STATIC_LIGHTS
			#warn HIDE_STATIC_LIGHTS flag is on
			world.log << "WARNING: HIDE_STATIC_LIGHTS flag is on"
			#endif
*/

			#ifdef DISABLE_BLENDING
			#warn DISABLE_BLENDING flag is on
			world.log << "WARNING: DISABLE_BLENDING flag is on"
			#endif

			#ifdef TESTING
			#warn TESTING flag is on
			world.log << "WARNING: TESTING flag is on"
			#endif

		..()