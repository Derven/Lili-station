Surface
	var
		// Left edge of the surface, as viewed from behind it. Stored as relative distance from bottom-left of source in tiles.
		leftX = 0 as num
		leftY = 0 as num

		// Right edge of the surface
		rightX = 1 as num
		rightY = 0 as num

		// How deep the light overlay should go
		depth = 32 as num
		heightOffset = 0 as num

		layer = LAYER_BACK_WALL_DYNAMIC_LIGHT
		plane = 0
		absX = 0
		absY = 0
		absZ = 0

		tmp
			// Surface normal
			normalX
			normalY

			// Length of surface (in tiles)
			length
			lengthInv

			// Vector from left to right (in tiles)
			deltaX
			deltaY

			boundX
			boundY
			boundWidth
			boundHeight

			matrix/rotationTransform

			global/image/lightOverlay

	New(atom/setLoc, setLeftX, setLeftY, setRightX, setRightY, setDepth, setOffset, setLayer, setPlane)
		if(setLeftX != null) leftX = setLeftX
		if(setLeftY != null) leftY = setLeftY
		if(setRightX != null) rightX = setRightX
		if(setRightY != null) rightY = setRightY
		if(setDepth != null) depth = setDepth
		if(setOffset != null) heightOffset = setOffset
		if(setLayer != null) layer = setLayer
		if(setPlane != null) plane = setPlane
		absX = setLoc.x
		absY = setLoc.y
		absZ = setLoc.z

		deltaX = rightX - leftX
		deltaY = rightY - leftY

		// The normal is the left->right vector, rotated 90deg ccw
		normalX = -deltaY
		normalY = deltaX
		length = sqrt(normalX*normalX + normalY*normalY)
		lengthInv = 1.0 / length
		normalX *= lengthInv
		normalY *= lengthInv

		boundX = leftX
		boundY = leftY
		boundWidth = (rightX - leftX) - PIXEL_IN_TILES*normalX
		boundHeight = (rightY - leftY) - PIXEL_IN_TILES*normalY
		if(boundWidth < 0)
			boundX += boundWidth
			boundWidth = -boundWidth
		if(boundHeight < 0)
			boundY += boundHeight
			boundHeight = -boundHeight

		if(!lightOverlay)
			lightOverlay = image(icon=WALL_LIGHT_ICON)

		// Create a rotation matrix for the normal rotated 90deg CCW
		rotationTransform = MATRIX_MATRIX(normalY, -normalX, \
		                                  normalX, normalY, \
		                                  0,  0)


	proc
		ApplyShadows(Light/light, atom/movable/target=light, list/overlayOverride = null)
			/*
				1) Identify each shadowed segment of the surface
				2) Use each shadowed segment to partition a list of lit segments
				3) If any lit segments cross a cardinal axes of the light, split it along that axes
				     (this is because the gradient will reverse at these points)
				4) Determine the light level at both sides of each lit segment
				5) Trim down any lit segments with portions that are outside the range of the light
				5) Create light icons; set scale, rotation, position, and alpha to match desired gradient segment
			*/
			//TESTOUT("Bounds: [bound_x], [bound_y] ([bound_width]x[bound_height])")
			TESTOUT("length: [length] [length*WORLD_ICON_HEIGHT]")

			var
				absLeftX = leftX + absX
				absLeftY = leftY + absY
				absRightX = rightX + absX
				absRightY = rightY + absY
				// <dx,dy> is vector from left side of surface to light
				dx = light.absX - absLeftX
				dy = light.absY - absLeftY
				// orthogonal distance from the surface to the light
				orthDist = dx*normalX + dy*normalY

			// Test if the surface is within the light's range
			if(orthDist > light.lightRange)
				TESTOUT("Surface beyond lights range ([orthDist] > [light.lightRange])")
				return

			// Test if the surface even faces the light
			if(orthDist <= 0)
				TESTOUT("Surface faces away from light (orthDist: [orthDist])")
				return

			TESTOUT("Surface faces light and within range (orthDist: [orthDist])")

			// Start out with a fully lit strip
			LightStrip.SetToFullyLit(length)

			// Apply each shadow to the strip
			for(var/i = 1 to light.shadowRays.len step 8)
				var
					// Absolute position of occluder's left shadow point
					shadowLeftX =    light.shadowRays[i+0]
					shadowLeftY =    light.shadowRays[i+1]
					// Normalized vector in direction of the left cast shadow
					shadowLeftNX =   light.shadowRays[i+2]
					shadowLeftNY =   light.shadowRays[i+3]
					// Absolute position of occluder's right shadow point
					shadowRightX =   light.shadowRays[i+4]
					shadowRightY =   light.shadowRays[i+5]
					// Normalized vector in direction of the right cast shadow
					shadowRightNX =  light.shadowRays[i+6]
					shadowRightNY =  light.shadowRays[i+7]

					// Vector from left shadow point on occluder to left surface point
					shadowLeftToSurfaceLeftX = absLeftX - shadowLeftX
					shadowLeftToSurfaceLeftY = absLeftY - shadowLeftY
					// Vector from right shadow point on occluder to left surface point
					shadowRightToSurfaceLeftX = absLeftX - shadowRightX
					shadowRightToSurfaceLeftY = absLeftY - shadowRightY

					// Vector from left shadow point on occluder to right surface point
					shadowLeftToSurfaceRightX = absRightX - shadowLeftX
					shadowLeftToSurfaceRightY = absRightY - shadowLeftY
					// Vector from right shadow point on occluder to right surface point
					shadowRightToSurfaceRightX = absRightX - shadowRightX
					shadowRightToSurfaceRightY = absRightY - shadowRightY

					// Vector from right shadow point to left shadow point on occluder
					shadowRightToShadowLeftX = shadowLeftX - shadowRightX
					shadowRightToShadowLeftY = shadowLeftY - shadowRightY

				// Test that at least one surface point is within the shadow right->left plane
				if(shadowRightToSurfaceRightX * shadowRightToShadowLeftY + shadowRightToSurfaceRightY * -shadowRightToShadowLeftX <= HALF_PIXEL_IN_TILES \
				        && shadowRightToSurfaceLeftX * shadowRightToShadowLeftY + shadowRightToSurfaceLeftY * -shadowRightToShadowLeftX <= HALF_PIXEL_IN_TILES)

					TESTOUT("Surface is outside shadow's forward right->left plane")
					continue
				else
					TESTOUT("Surface is within shadow's forward right->left plane ([shadowRightToSurfaceRightX * shadowRightToShadowLeftY + shadowRightToSurfaceRightY * -shadowRightToShadowLeftX] <= 0 && [shadowRightToSurfaceLeftX * shadowRightToShadowLeftY + shadowRightToSurfaceLeftY * -shadowRightToShadowLeftX] <= 0)")

				// Determine if the surface is fully contained within the shadow arc
				// This will help to avoid some edge cases
				// First test if the left surface point is within the 3 planes
				if(shadowLeftToSurfaceLeftX * shadowLeftNY + shadowLeftToSurfaceLeftY * -shadowLeftNX > 0 /* Within left shadow ray plane */ \
				        && shadowRightToSurfaceLeftX * -shadowRightNY + shadowRightToSurfaceLeftY * shadowRightNX > 0 /* Within right shadow ray plane */ \
				        && shadowRightToSurfaceLeftX * shadowRightToShadowLeftY + shadowRightToSurfaceLeftY * -shadowRightToShadowLeftX > 0 /* Within shadow left->right plane */ )

					// Now test if the right surface point is within the 3 planes
					if(shadowLeftToSurfaceRightX * shadowLeftNY + shadowLeftToSurfaceRightY * -shadowLeftNX > 0 /* Within left shadow ray plane */ \
					        && shadowRightToSurfaceRightX * -shadowRightNY + shadowRightToSurfaceRightY * shadowRightNX > 0 /* Within right shadow ray plane */ \
					        && shadowRightToSurfaceRightX * shadowRightToShadowLeftY + shadowRightToSurfaceRightY * -shadowRightToShadowLeftX > 0 /* Within shadow left->right plane */ )

						TESTOUT("Surface is fully contained within the shadow ray arc")

						LightStrip.SetToFullyUnlit(length)

						break // Fully covered, no point in continuing

				// Determine where the shadow rays fall on the surface
				//    <http://stackoverflow.com/questions/563198/how-do-you-detect-where-two-line-segments-intersect>
				// p = shadowLeft, r = shadowLeftN
				// q = surfaceLeft, s = surfaceRight - surfaceLeft
				// t = parametric value along shadow ray = ((q - p) x s) / (r x s)
				// u = parametric value along surface =    ((q - p) x r) / (r x s)

				var
					// (r x s)
					leftCrossRS = CROSS(shadowLeftNX, shadowLeftNY, deltaX, deltaY)
					rightCrossRS = CROSS(shadowRightNX, shadowRightNY, deltaX, deltaY)

					// The parametric value along the surface, for the left shadow ray
					leftSurfaceParametric = null // Start with invalid values
					// The parametric value along the surface, for the right shadow ray
					rightSurfaceParametric = null

				TESTOUT("leftCrossRS:		[leftCrossRS]")

				// Test that the ray and surface aren't parallel
				if(leftCrossRS != 0)
					var
						// 1 / (r x s)
						leftInverseCrossRS = 1.0 / leftCrossRS
						// ((q - p) x s) / (r x s)
						leftShadowParametric = CROSS(shadowLeftToSurfaceLeftX, shadowLeftToSurfaceLeftY, deltaX, deltaY) * leftInverseCrossRS

					TESTOUT("leftShadowParametric:	[leftShadowParametric]")

					// Test that the surface is infront of the ray (with some threshold to avoid self-shadowing)
					// TODO: This test (and the right-side one) causes mob shading issues when standing right next to a wall, but if we remove it, it causes wall shadows to sometimes disappear
					//       Need to replace it with a more robust calculation, maybe considering the signs of both the shadow and surface parametric values
					if(leftShadowParametric > HALF_PIXEL_IN_TILES)
						// ((q - p) x r) / (r x s)
						leftSurfaceParametric = CROSS(shadowLeftToSurfaceLeftX, shadowLeftToSurfaceLeftY, shadowLeftNX, shadowLeftNY) * leftInverseCrossRS

						TESTOUT("leftSurfaceParametric:	[leftSurfaceParametric]")

						// Test that the surface is between the left and right rays
						if(leftSurfaceParametric <= 0.0)
							TESTOUT("Left ray lands beyond left side of surface")
							continue
						else if(leftSurfaceParametric > 1.0)
							leftSurfaceParametric = 1.0

				TESTOUT("rightCrossRS:		[rightCrossRS]")

				// Test that the ray and surface aren't parallel
				if(rightCrossRS != 0)
					var
						// 1 / (r x s)
						rightInverseCrossRS = 1.0 / rightCrossRS
						// ((q - p) x s) / (r x s)
						rightShadowParametric = CROSS(shadowRightToSurfaceLeftX, shadowRightToSurfaceLeftY, deltaX, deltaY) * rightInverseCrossRS

					TESTOUT("rightShadowParametric:	[rightShadowParametric]")

					// Test that the surface is infront of the ray (with some threshold to avoid self-shadowing)
					if(rightShadowParametric > HALF_PIXEL_IN_TILES)
						// ((q - p) x r) / (r x s)
						rightSurfaceParametric = CROSS(shadowRightToSurfaceLeftX, shadowRightToSurfaceLeftY, shadowRightNX, shadowRightNY) * rightInverseCrossRS

						TESTOUT("rightSurfaceParametric:	[rightSurfaceParametric]")

						// Test that the surface is between the left and right rays
						if(rightSurfaceParametric >= 1.0)
							TESTOUT("Right ray lands beyond right side of surface")
							continue
						else if(rightSurfaceParametric < 0.0)
							rightSurfaceParametric = 0.0

				// If one of the two rays didn't intersect, assume it fills that side
				// Also limit the range to the area of the surface [0.0, 1.0]
				if(leftSurfaceParametric == null)
					if(rightSurfaceParametric == null)
						TESTOUT("Shadow rays do not intersect surface")
						continue
					leftSurfaceParametric = 1.0
				else
					if(rightSurfaceParametric == null)
						rightSurfaceParametric = 0.0

				TESTOUT({"
leftSurfaceParametric'			[leftSurfaceParametric]
rightSurfaceParametric'			[rightSurfaceParametric]"})
				// Check if the shadow fell within the valid area of the surface
				if(leftSurfaceParametric <= rightSurfaceParametric)
					TESTOUT("Shadows do not fall on surface")
					continue


				leftSurfaceParametric *= length
				rightSurfaceParametric *= length

				TESTOUT("ApplyShadow([rightSurfaceParametric],[leftSurfaceParametric])")
				LightStrip.ApplyShadow(rightSurfaceParametric, leftSurfaceParametric)

				// If the strip is fully covered in shadow at this point, we can bail-out
				if(LightStrip.IsFullyUnlit())
					TESTOUT("Surface is fully unlit")
					return

			////////////////////////////////////////
			// Create a sprite for each lit segment
			////////////////////////////////////////

			// Calculate where the radius of the light hits the surface
			var
				// tangential distance/offset along the surface to the light
				tangDist = dx*normalY - dy*normalX
				// How far in either direction from the nearest point the light radius reaches
				// Derived from r^2 = x^2 + y^2
				lightTangRange = sqrt(light.lightRange*light.lightRange - orthDist*orthDist)
				lightMin = tangDist - lightTangRange
				lightMax = tangDist + lightTangRange

			TESTOUT("tangDist:\t[tangDist]")
			TESTOUT("lightTangRange:\t[lightTangRange] (sqrt([light.lightRange]*[light.lightRange] - [orthDist]*[orthDist]) = sqrt([light.lightRange*light.lightRange] - [orthDist*orthDist]) )")
			TESTOUT("lightMin:\t[lightMin]")
			TESTOUT("lightMax:\t[lightMax]")

			if(tangDist > 0 && tangDist < length)
				// In case we have a lit segment at the point where the gradient reverses, split it
				LightStrip.SplitLitSegmentAtPoint(tangDist)

			var
				// Offset in pixels from target to surface (for overlays)
				offsetX = (absLeftX - target.GetAbsX())*world.icon_size + (16*rotationTransform.a - 16*rotationTransform.b)
				offsetY = (absLeftY - target.GetAbsY())*world.icon_size + (16*rotationTransform.d - 16*rotationTransform.e)

				segStart = 0     // Distance from the "left" side of the strip
				segEnd           // Where the current segment ends
				lightStart
				lightEnd
				lightLength
				lightStartAlpha
				lightEndAlpha

			lightOverlay.blend_mode = BLEND_ADD //###TEST
			lightOverlay.layer = src.layer
			lightOverlay.plane = src.plane //###TEST Better or worse for performance? Could work with or without plane, since there are no shadows

			for(var/index = 1 to LightStrip.segments.len step 2)
				segEnd = segStart + LightStrip.segments[index]
				TESTOUT("Lit segment\[[index]\]: [segStart]-[segEnd] ([segEnd-segStart])")

				lightStart = max(lightMin, segStart)
				lightEnd = min(lightMax, segEnd)
				lightLength = lightEnd - lightStart

				// Ignore segments less than half a pixel in length
				if(lightLength < HALF_PIXEL_IN_TILES)
					TESTOUT("Segment too small to draw (lightLength: [lightLength])")
				else
					var/flip = (lightStart >= tangDist) ? -1 : 1
					// Set the origin to left,top and flip the icon if necessary
					var/matrix/m = MATRIX_MATRIX(flip,                  0, \
					                             0,                     1, \
					                             WALL_LIGHT_WIDTH_HALF, -WALL_LIGHT_HEIGHT_HALF)
					// Scale the icon to fill the lit strip segment
					var/scaleX = lightLength * WORLD_ICON_WIDTH / WALL_LIGHT_WIDTH
					var/scaleY = depth / WALL_LIGHT_HEIGHT
					// Scale to fit the surface and translate by the starting offset
					m *= MATRIX_LIST(scaleX,                      0, \
					                 0,                           scaleY, \
					                 lightStart*WORLD_ICON_WIDTH - WORLD_ICON_WIDTH_HALF, WORLD_ICON_WIDTH_HALF)

					m *= rotationTransform
					// Translate the icon back over the surface
					m.c += WORLD_ICON_WIDTH_HALF - WALL_LIGHT_WIDTH_HALF
					m.f += WORLD_ICON_HEIGHT_HALF - WALL_LIGHT_HEIGHT_HALF

					// Offset from the light to the wall
					m.c += offsetX
					m.f += offsetY

					// Offset where the light appears to create the illusion of height
					m.f += heightOffset

					TESTOUT("Surface Matrix:\n\t[m.a]\t[m.d]\n\t[m.b]\t[m.e]\n\t[m.c]\t[m.f]")

					TESTOUT("lightStart:\t[lightStart]")
					TESTOUT("lightEnd:\t[lightEnd]")

					// Calculate the light level at both sides of the segment
					// Level = 1.0 - (distSqr / lightRangeSqr)
					var
						sdx = dx - lightStart*normalY
						sdy = dy + lightStart*normalX
					lightStartAlpha = max(0.00001, 1.0 - ((sdx*sdx+sdy*sdy) / (light.lightRange*light.lightRange)))
					sdx = dx - lightEnd*normalY
					sdy = dy + lightEnd*normalX
					lightEndAlpha = max(0.00001, 1.0 - ((sdx*sdx+sdy*sdy) / (light.lightRange*light.lightRange)))

					// Old version, based on distance from radius edge, too steep of a falloff for vertical distance
					//lightStartAlpha = 1.0 - (abs(lightStart - tangDist) / lightTangRange)
					//lightEndAlpha = 1.0 - (abs(lightEnd - tangDist) / lightTangRange)


					if(flip < 0)
						TESTOUT("FLIPPED")
						var/temp = lightStartAlpha
						lightStartAlpha = lightEndAlpha
						lightEndAlpha = temp
					else
						TESTOUT("NOT FLIPPED")

					TESTOUT("lightStartAlpha:\t[lightStartAlpha]")
					TESTOUT("lightEndAlpha:\t[lightEndAlpha]")

					lightOverlay.alpha = 255*lightEndAlpha
					lightOverlay.icon_state = "[min(255,round(255*lightStartAlpha/lightEndAlpha, WALL_LIGHT_STEP))]"
					TESTOUT("I.alpha:\t[lightOverlay.alpha]")
					TESTOUT("I.icon_state:\t[lightOverlay.icon_state] (255*[lightStartAlpha]/[lightEndAlpha]) = 255*[lightStartAlpha/lightEndAlpha] = [255*lightStartAlpha/lightEndAlpha])")
					lightOverlay.transform = m
					if(overlayOverride)
						overlayOverride += lightOverlay.appearance
					else
						target.overlays += lightOverlay

				segStart = segEnd
				// Add in the length of the following unlit segment
				if(index < LightStrip.segments.len)
					segStart += LightStrip.segments[index+1]
					TESTOUT("Skipping unlit segment of length [LightStrip.segments[index+1]]")

	Static
		New()
			..()
			var/SpatialGrid/g = GetSpatialGrid(absZ)
			g.Add(src, boundX+absX, boundY+absY, boundWidth, boundHeight)

	Movable
		proc
			SetPosition(atom/movable/A)
				// TODO: Optimize to only update grid if we know we changed cells
				//var/SpatialGrid/g = GetSpatialGrid(absZ)
				//g.Remove(src, boundX+absX, boundY+absY, boundWidth, boundHeight)

				absX = A.GetAbsX()
				absY = A.GetAbsY()
				absZ = A.z

				//g.Add(src, boundX+absX, boundY+absY, boundWidth, boundHeight)