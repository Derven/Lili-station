
var/OUTPUT_TEST = FALSE
client/verb/OutputTest()
#ifdef TESTING
	world<<"\n\n=============================\n=========================\n====================\n\n"
	OUTPUT_TEST = TRUE
	for(var/Light/L in world)
		world<<"Updating /Light [L] at ([L.x],[L.y],[L.z])\n"
		L.UpdateShadows()
	OUTPUT_TEST = FALSE
#else
	return
#endif


proc/UpdateAllLights()
	for(var/Light/L in world)
		L.SetPosition(L)

Light
	parent_type = /obj

	var/const/RADIUS_OVERLAY_OFFSET = (608 - 32) * 0.5
	var/global/NEXT_LIGHT_PLANE = -99

	appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR //KEEP_TOGETHER
	blend_mode = BLEND_ADD
	//luminosity = LIGHT_RADIUS // Just large enough for 512x512 light field
	name = ""
	mouse_opacity = 0

	var
		lightRange = 256 / WORLD_ICON_WIDTH
		lightIcon = 'LightRadius.jpg'
		absX = 1
		absY = 1
		// List in the form of [absX, absY, dx, dy]
		list/shadowRays = list()
		image/lightRadius

	New()
		plane = NEXT_LIGHT_PLANE++

		#warn TODO: Need to assign/recycle planes
		ASSERT(NEXT_LIGHT_PLANE < 0)
		lightRadius = image(icon=lightIcon, pixel_x = -RADIUS_OVERLAY_OFFSET, pixel_y = -RADIUS_OVERLAY_OFFSET, layer=LAYER_DYNAMIC_LIGHT)
		lightRadius.plane = src.plane
		underlays += lightRadius

	proc
		SetPosition(atom/movable/A)
			loc = A.loc
			step_x = A.step_x
			step_y = A.step_y

			absX = GetAbsX()
			absY = GetAbsY()

			UpdateShadows()

		SetColor(c)
			underlays -= lightRadius
			color = c
			underlays += lightRadius

		UpdateShadows()
			// Wipe old shadows
			overlays.Cut()
			shadowRays.Cut()

			UpdateLight()

			// Get all turfs within range of the light
			var/list/objects = range(LIGHT_RADIUS, src)
			//var/list/turfs = block(locate(max(1, x-LIGHT_RADIUS), max(1, y-LIGHT_RADIUS), z), \
			                       locate(min(world.maxx, x+LIGHT_RADIUS), min(world.maxy, y+LIGHT_RADIUS)))

			// Calculate shadows cast by occluders
			for(var/Occluder/m in objects)
				TESTOUT("\nOccluder at [m.x],[m.y]")
				m.GenerateShadow(src)

			for(var/mob/m in objects)
				TESTOUT("\nMob at [m.x],[m.y]")
				m.UpdateLight(src)

			var/SpatialGrid/g = GetSpatialGrid(z)
			var/list/data = g.Search(max(1.0, absX-0.5-LIGHT_RADIUS), max(1.0, absY-0.5-LIGHT_RADIUS), LIGHT_SIZE, LIGHT_SIZE)

			// Cast shadows onto non-floor surface planes
			for(var/Surface/m in data)
				TESTOUT("\nSurface at [m.absX],[m.absY]")
				m.ApplyShadows(src)

		UpdateLight()
			// For directional lights to override

	DirectionalLight
		lightIcon = 'LightRadiusBi.jpg'
		var
			rotationAngle = 0
			lastRotationAngle = null
			list/sourceShadowVectors = list(0.818835,0.574029, 0.818835,-0.574029, -0.818835,-0.574029, -0.818835, 0.574029)
			list/rotatedShadowRays = list()
		UpdateLight()
			if (rotationAngle != lastRotationAngle)
				lastRotationAngle = rotationAngle
				var/matrix/m = new/matrix()
				m.Turn(-rotationAngle)
				underlays -= lightRadius
				lightRadius.transform = m
				underlays += lightRadius
				rotatedShadowRays.len = sourceShadowVectors.len*2
				for(var/i = 1 to sourceShadowVectors.len step 2)
					var/j = (i-1)*2+1
					rotatedShadowRays[j+2] = sourceShadowVectors[i]*m.a + sourceShadowVectors[i+1]*m.b
					rotatedShadowRays[j+3] = sourceShadowVectors[i]*m.d + sourceShadowVectors[i+1]*m.e
					rotatedShadowRays[j] = absX + rotatedShadowRays[j+2]/16 /////// TEST just to shift the points away from eachother
					rotatedShadowRays[j+1] = absY + rotatedShadowRays[j+3]/16 /////// TEST just to shift the points away from eachother
			shadowRays.Add(rotatedShadowRays)
		New()
			..()
			rotationAngle = rand(0,359)
			RotationLoop()
		proc
			RotationLoop()
				spawn()
					while(loc)
						rotationAngle = (rotationAngle+3)%360
						UpdateShadows()
						sleep(world.tick_lag)

Shape
	var
		list/points

	New(list/points)
		src.points = points

atom/movable
	proc
		GetAbsX()
			return x + (step_x + bound_x + bound_width * 0.5) / world.icon_size
		GetAbsY()
			return y + (step_y + bound_y + bound_height * 0.5) / world.icon_size
		GetRelPX()
			return (step_x + bound_x + bound_width * 0.5)
		GetRelPY()
			return (step_y + bound_y + bound_height * 0.5)