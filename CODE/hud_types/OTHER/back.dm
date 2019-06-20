obj/hud
	back
		layer = 16
		icon = 'screen1.dmi'
		icon_state = "back2"
		screen_loc = "SOUTH-1, WEST to SOUTH-1, EAST"

		New(var/mob/M)
			..()
			iam = M