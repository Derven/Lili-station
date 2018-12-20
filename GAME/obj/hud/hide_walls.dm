/obj/hud
	hide_walls
		icon_state = "hide_wall"
		screen_loc = "SOUTH-1, WEST+6"

		Click()
			for(var/turf/simulated/wall/W in view(iam))
				W.hide_me()
				spawn(25)
					W.clear_images()