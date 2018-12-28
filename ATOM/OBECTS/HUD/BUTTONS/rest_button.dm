/obj/hud
	rest
		icon_state = "rest"
		screen_loc = "SOUTH-1, WEST+3"

		Click()
			iam.resting()
			flick("rest_click", src)
