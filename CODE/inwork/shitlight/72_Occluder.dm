Occluder
	icon = null
	density = 0
	parent_type = /obj
	name = ""
	var
		// List of x,y point pairs, relative to bottom-left of source tile
		list/points = list(0,0,   1,0,   1,1,   0,1)
		tmp
			Shape/shape
			// TODO: Can make these global and have all occluders share them?
			image
				shadowLeft
				shadowRight
				shadowCenter
				shadowLeftSquare
				shadowRightSquare

	Rectangle
		var
			shapeWidth = 1 as num
			shapeHeight = 1 as num
		New(atom/setLoc, setShapeWidth, setShapeHeight)
			if(setShapeWidth) shapeWidth = setShapeWidth
			if(setShapeHeight) shapeHeight = setShapeHeight
			bound_width = shapeWidth * world.icon_size
			bound_height = shapeHeight * world.icon_size
			points = list(0,           0, \
			              shapeWidth,  0, \
			              shapeWidth,  shapeHeight, \
			              0,           shapeHeight)
			..()

	Triangle
		//icon = 'Turfs.dmi'
		//icon_state = "triangle"
		points = list(0,0,   1,0,   0.5,0.78125)

	New()
		shape = new/Shape(points)

		shadowLeft = image(icon='Triangle.png', layer=LAYER_DYNAMIC_SHADOW)
		shadowRight = image(icon='Triangle.png', layer=LAYER_DYNAMIC_SHADOW)
		shadowCenter = image(icon='Black.dmi', layer=LAYER_DYNAMIC_SHADOW)
		shadowLeftSquare = image(icon='Black.dmi', layer=LAYER_DYNAMIC_SHADOW)
		shadowRightSquare = image(icon='Black.dmi', layer=LAYER_DYNAMIC_SHADOW)

		shadowLeft.blend_mode=BLEND_OVERLAY
		shadowRight.blend_mode=BLEND_OVERLAY
		shadowCenter.blend_mode=BLEND_OVERLAY
		shadowLeftSquare.blend_mode=BLEND_OVERLAY
		shadowRightSquare.blend_mode=BLEND_OVERLAY

		#ifdef TESTING
		shadowLeft.color = list(null, null, null, null, "#FF000000")
		shadowRight.color = list(null, null, null, null, "#00FF0000")
		shadowCenter.color = list(null, null, null, null, "#0000FF00")
		shadowLeftSquare.color = list(null, null, null, null, "#FFFF0000")
		shadowRightSquare.color = list(null, null, null, null, "#00FFFF00")
		#endif

	proc
		GenerateShadow(Light/light)
			// TODO: Bail out if occluder is outside light range
			var
				// Light's center
				lightX = light.GetAbsX()
				lightY = light.GetAbsY()
				// Occluder's origin (bottom-left)
				shapeX = src.x
				shapeY = src.y

			/////////////////////////////////////////////////////////////
			// Calculate the silhouette points of the occluding shape

			// D = <sx-lx, sy-ly>            (light to shape center)
			// P = <p[n].x-lx, p[n].y-ly>    (light to shape point)
			// dot(D, P) = ||D||*||P||*cos(theta)
			// To get a dot() range of -1 to +1, we'll rotate D by 90deg
			// The points with the min and max dots (after normalization) are the extremes

			var
				// Vector from light to shape center
				dx = shapeX - lightX
				dy = shapeY - lightY
				offsetX = dx*world.icon_size + 16
				offsetY = dy*world.icon_size + 16
				dInvMag = 1.0 / sqrt(dx*dx + dy*dy)
				dnx = dx * dInvMag
				dny = dy * dInvMag

				// Vector rotated -90deg ccw
				rnx = dny
				rny = -dnx

				// Vector from light to each shape point
				px;py;pInvMag;pnx;pny

				dotMag
				dotDir

				minDot = 1.1 // Any valid dot will be smaller than this
				minIndex
				minDX
				minDY
				maxDot = 1.1 // Any valid dot will be smaller than this
				maxIndex
				maxDX
				maxDY

			for(var/i = 1 to shape.points.len step 2)
				px = shape.points[i] + shapeX - lightX
				py = shape.points[i+1] + shapeY - lightY
				pInvMag = 1.0 / sqrt(px*px + py*py)
				pnx = px * pInvMag
				pny = py * pInvMag

				dotDir = rnx*pnx + rny*pny
				dotMag = dnx*pnx + dny*pny

				if(OUTPUT_TEST)
					world << "Point\[[i]\]: [shape.points[i]], [shape.points[i+1]] => [px], [py] ([pnx],[pny]) @ [dotMag]/[dotDir]"

				if(dotMag < minDot && dotDir <= 0)
					minDot = dotMag
					minIndex = i
					minDX = pnx
					minDY = pny
				if(dotMag < maxDot && dotDir >= 0)
					maxDot = dotMag
					maxIndex = i
					maxDX = pnx
					maxDY = pny

			if(OUTPUT_TEST)
				world << "Selected min [minIndex] and max [maxIndex]"

			/////////////////////////////////////////////////////////////
			// Calculate the origin, rotation, and scale of the triangles

			var
				matrix/trans

				// Left shadow point
				apx = step_x + shape.points[minIndex]*world.icon_size
				apy = step_y + shape.points[minIndex+1]*world.icon_size

				// Right shadow point
				bpx = step_x + shape.points[maxIndex]*world.icon_size
				bpy = step_y + shape.points[maxIndex+1]*world.icon_size

			// Store the shadow rays for use later
			light.shadowRays.Add(
					x + apx / world.icon_size,
					y + apy / world.icon_size,
					minDX,
					minDY,
					x + bpx / world.icon_size,
					y + bpy / world.icon_size,
					maxDX,
					maxDY)

			if(OUTPUT_TEST)
				world << {"
apx			[apx]
apy			[apy]
bpx			[bpx]
bpy			[bpy]
maxDX			[maxDX]
maxDY			[maxDY]
dnx			[dnx]
dny			[dny]
"}

			shadowLeft.plane = light.plane
			shadowRight.plane = light.plane
			shadowCenter.plane = light.plane
			shadowLeftSquare.plane = light.plane
			shadowRightSquare.plane = light.plane

			var
				aDot = dnx*minDX + dny*minDY
				bDot = dnx*maxDX + dny*maxDY
				aTargetSlope = (minDX != 0) ? minDY / minDX : 0
				bTargetSlope = (maxDX != 0) ? maxDY / maxDX : 0
				aScale = 0
				bScale = 0

				// We use the normalized light-to-shape vector as the cos and sin values for the triangle rotation matrix
				aRotMat = MATRIX_LIST(dnx,   dny, \
				                      -dny,  dnx, \
				                      0,     0)
				bRotMat = aRotMat

			// Check if the left ray angle is so large that it needs an additional square shape
			// If the dot of the left ray and the light->shape vector is less than 0, the arc is greater than 90 degrees and will need a square to fill it
			if(aDot <= 0)
				// Target angle is beyond 90deg, so add a square to the shape
				var/matrix/m = MATRIX_MATRIX(1.0,   0.0, \
				                             0.0,   1.0, \
				                             16,    16)
				m.Scale(16.0, 16.0)
				m *= aRotMat
				m.Translate(apx - 16 + offsetX,  apy - 16 + offsetY)
				shadowLeftSquare.transform = m
				light.overlays += shadowLeftSquare

				// If the dot is exactly zero, we don't need a triangle, just the square
				if(aDot != 0)
					// Rotate the triangle an additional 90 deg ccw
					aRotMat = MATRIX_LIST(-dny,  dnx, \
					                      -dnx,  -dny, \
					                      0,     0)

					// Calculate Scale for offsetting triangle by another 90 deg CCW
					aScale = (minDX != 0) ? (aTargetSlope * (-dny) - dnx) / ((-dny) + aTargetSlope * dnx) \
					                      : (-dny) / (dnx) // (aTargetSlope * dnx - dny) / (dnx + aTargetSlope * dny)
			else
				aScale = (minDX != 0) ? (aTargetSlope * dnx - dny) / (dnx + aTargetSlope * dny) \
				                      : (dnx) / (dny) // (aTargetSlope * dny + dnx) / (dny + aTargetSlope * -dnx)


			// Check if the right ray angle is so large that it needs an additional square shape
			// If the dot of the right ray and the light->shape vector is less than 0, the arc is greater than 90 degrees and will need a square to fill it
			if(bDot <= 0)
				// Target angle is beyond 90deg, so add a square to the shape
				var/matrix/m = MATRIX_MATRIX(1.0,   0.0, \
				                             0.0,   1.0, \
				                             16,    16)
				m.Scale(16.0, -16.0)
				m *= bRotMat
				m.Translate(bpx - 16 + offsetX,  bpy - 16 + offsetY)
				shadowRightSquare.transform = m
				light.overlays += shadowRightSquare

				// If the dot is exactly zero, we don't need a triangle, just the square
				if(bDot != 0)
					// Rotate the triangle an additional 90 deg cw
					bRotMat = MATRIX_LIST(dny,   -dnx, \
					                      dnx,   dny, \
					                      0,     0)

					// Calculate Scale for offsetting triangle by another 90 deg CW
					bScale = (maxDX != 0) ? (bTargetSlope * dny + dnx) / (dny + bTargetSlope * -dnx) \
					                      : (dny) / (-dnx) // (bTargetSlope * -dnx + dny) / (-dnx + bTargetSlope * -dny)
			else
				bScale = (maxDX != 0) ? (bTargetSlope * dnx - dny) / (dnx + bTargetSlope * dny) \
				                      : (dnx) / (dny) // (bTargetSlope * dny + dnx) / (dny + bTargetSlope * -dnx)

			/////////////////////////////////////////////////////////////
			// Transforming the triangles
			//    1. Translate to place origin in bottom-left corner
			//    2. Scale triangle along y-axis to match light->point slope
			//    3. Rotate triangle to match light->shape vector
			//    4. Translate triangle to place at shape shadow point

			var/halfIconSize = TRIANGLE_ICON_SIZE * 0.5

			//////////////////////////////////////
			// Transform the left side triangle

			if(aScale != 0)
				//    1. Translate to place origin in bottom-left corner
				trans = MATRIX_MATRIX(1.0,          0.0, \
				                      0.0,          1.0, \
				                      halfIconSize, halfIconSize)

				//    2. Scale triangle along y-axis to match light->point slope
				trans.Scale(1.0, aScale)

				//    3. Rotate triangle to match light->shape vector
				trans *= aRotMat

				//    4. Translate triangle to place at shape shadow point
				trans.Translate(apx - halfIconSize + offsetX,  apy - halfIconSize + offsetY)

				shadowLeft.transform = trans

				light.overlays += shadowLeft


			//////////////////////////////////////
			// Transform the right side triangle

			if(bScale != 0)
				trans = MATRIX_MATRIX(1.0,          0.0, \
				                      0.0,          1.0, \
				                      halfIconSize, halfIconSize)
				trans.Scale(1.0, bScale)
				trans *= bRotMat
				trans.Translate(bpx - halfIconSize + offsetX,  bpy - halfIconSize + offsetY)
				shadowRight.transform = trans
				light.overlays += shadowRight

			//////////////////////////////////////
			// Transform the center square
			var
				// Calculate the gap between the triangles by projecting the pointA->pointB vector
				//    against the 90deg CW rotated light->shape vector
				const/FUZZ = 0.01
				gap = rnx*(bpx - apx) + rny*(bpy - apy) + FUZZ + FUZZ
				// Calculate how far the square will stick out from the edge (like gap, but not rotated)
				outcrop = dnx*(bpx - apx) + dny*(bpy - apy) + FUZZ
				shear = (outcrop != 0) ? outcrop/gap : 0
				//cpx = -rnx * gap * 0.5
				//cpy = -rny * gap * 0.5
				cScale = gap / 32.0

			// Move the origin to the top-center
			trans = MATRIX_MATRIX(1.0,          0.0, \
			                      0.0,          1.0, \
			                      16,           -16)
			// Scale to fill gap and extend the shadow
			trans.Scale(512.0, cScale)
			// Shear to match silhouette points
			trans *= MATRIX_LIST(1,     0, \
			                     -shear,     1, \
			                     0,     FUZZ)
			// Rotate to match light->shape vector
			trans *= MATRIX_LIST(dnx,   dny, \
			                     -dny,  dnx, \
			                     0,     0)
			// Position the square in the center of the gap
			trans.Translate(apx - 16 + offsetX,  apy - 16 + offsetY)

			shadowCenter.transform = trans

			light.overlays += shadowCenter
