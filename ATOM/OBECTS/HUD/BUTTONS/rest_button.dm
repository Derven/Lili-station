/obj/hud
	rest
		icon_state = "rest"
		screen_loc = "SOUTH-1, WEST+3"

		Click()
			var/mob/simulated/living/humanoid/H = iam
			H.resting()
			flick("rest_click", src)
