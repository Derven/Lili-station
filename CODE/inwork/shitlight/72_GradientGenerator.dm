#ifdef TESTING

client/verb/GenerateSurfaceGradients()
	var/const/sliceStep = WALL_LIGHT_STEP
	var/const/sliceWidth = WALL_LIGHT_WIDTH
	var/const/sliceHeight = WALL_LIGHT_HEIGHT


	var/icon/sliceTemplate = new('Blank.dmi')
	sliceTemplate.Crop(1, 1, sliceWidth, sliceHeight)

	var/icon/result = new()

	for(var/leftAlpha = 0 to 255 step sliceStep)

		var/icon/slice = new(sliceTemplate)

		for(var/x = 1 to sliceWidth)
			var/alpha = (x/sliceWidth) * (255 - leftAlpha) + leftAlpha
			slice.DrawBox(rgb(255,255,255,alpha), x, 1, x, sliceHeight)

		result.Insert(slice, "[leftAlpha]")

	fcopy(fcopy_rsc(result), "./GradientSlices_[time2text(world.realtime, "hhmmss")].dmi")

#endif