mob
	layer = LAYER_MOB
	sight = SEE_PIXELS
	//icon = 'Mob.dmi'
	//blend_mode = BLEND_SUBTRACT
	blend_mode = BLEND_ADD
	appearance_flags = KEEP_TOGETHER
	mouse_opacity = 0

	//see_in_dark = 0
	//layer = 100
	step_size = 4
	animate_movement = SYNC_STEPS
	bound_x = 4
	bound_y = 4
	bound_width = 24
	bound_height = 24
	//plane = 1

	var/tmp/obj/Lamp/lamp
	var/tmp/Surface/Movable/surface
	var/tmp/list/PerLightOverlays = list()

	proc
		UpdateLight(Light/L)
			if(surface)
				TESTOUT("Mob [src] updating lighting for light at [L.absX],[L.absY]")
				var/list/lightOverlays = PerLightOverlays[L]
				if(lightOverlays)
					overlays -= lightOverlays
					lightOverlays.Cut()
				else
					lightOverlays = list()
					PerLightOverlays[L] = lightOverlays

				surface.ApplyShadows(L, src, lightOverlays)

				overlays += lightOverlays
		UpdateAllLights()
			if(surface)
				overlays.Cut()
				PerLightOverlays.Cut()
				surface.SetPosition(src)
				var/list/objects = range(LIGHT_RADIUS, src)
				for(var/Light/L in objects)
					UpdateLight(L)

	Move()
		.=..()
		if(lamp)
			lamp.SetPosition(src)
		UpdateAllLights()
	Login()
		surface = new(src, 0.25, -0.30, -0.25, -0.30, 20, 0, LAYER_MOB_DYNAMIC_LIGHT, src.plane)
		#warn Mob icon layering issue with wall backs
		var/image/I = image(icon='Mob.dmi', layer=LAYER_MOB_BLACK)
		I.blend_mode = BLEND_OVERLAY
		I.appearance_flags = RESET_COLOR | KEEP_APART // Not a part of KEEP_TOGETHER
		I.color = "#000000FF"
		//I.plane = 0
		underlays += I


		var/list/invertColor = list(-1, 0, 0, 0, \
								    0, -1, 0, 0, \
								    0, 0, -1, 0, \
								    0, 0, 0, 1, \
								    1, 1, 1, 0 )
		I = image(icon='Mob.dmi', layer=LAYER_MOB)
		I.blend_mode = BLEND_MULTIPLY
		//I.plane = src.plane
		I.color = invertColor
		underlays += I
		src.color = invertColor
	Logout()
		del(src)

#ifdef TESTING
	verb
		TestVerbs()
			var/run = input("Run:") as null|anything in (verbs-/mob/verb/TestVerbs)
			if(run)
				call(src, run)()
		ListOverlays()
			src << "Overlays ([overlays.len]):"
			for(var/a in overlays)
				src << "[a:icon] / [a:icon_state] / [a:layer] / [a:plane] / [a:blend_mode]"
		TestSelfSurface()
			src << "[src.surface.absX],[src.surface.absY],[src.surface.absZ]"
#endif