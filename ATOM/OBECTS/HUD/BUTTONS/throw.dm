/obj/hud
	throwbutton
		icon_state = "throw1"
		screen_loc = "SOUTH-1, WEST+3"

		Click()
			if(iam.hand && iam.l_hand)
				icon_state = "throw2"
				iam.throwing_mode = 1
			if(!iam.hand && iam.r_hand)
				icon_state = "throw2"
				iam.throwing_mode = 1
			else
				return