/turf/unsimulated/floor


	planet
		icon_state = "asteroid"

		New()
			..()
			icon_state = "asteroid[pick("1","2","3","")]"
			if(prob(60))
				src = new /turf/simulated/wall/asteroid(src)
