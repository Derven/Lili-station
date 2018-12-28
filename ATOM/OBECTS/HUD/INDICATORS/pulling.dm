/obj/hud
	pulling
		icon_state = "pull_1"
		screen_loc = "SOUTH-1, WEST+2"

		Click()
			if(iam.pulling)
				iam.stop_pulling()