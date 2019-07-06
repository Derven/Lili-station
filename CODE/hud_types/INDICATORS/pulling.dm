/obj/hud
	pulling
		icon_state = "pull_1"
		screen_loc = "SOUTH-1, WEST+1"

		Click()
			var/mob/simulated/living/humanoid/H = iam
			if(H.pulling)
				H.stop_pulling()