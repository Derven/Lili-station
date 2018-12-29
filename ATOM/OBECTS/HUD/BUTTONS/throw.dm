/obj/hud
	throwbutton
		icon_state = "throw1"
		screen_loc = "SOUTH-1, WEST+3"

		Click()
			var/mob/simulated/living/humanoid/H = iam
			if(H.hand && H.l_hand)
				icon_state = "throw2"
				H.throwing_mode = 1
			if(!H.hand && H.r_hand)
				icon_state = "throw2"
				H.throwing_mode = 1
			else
				return